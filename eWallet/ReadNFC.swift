//
//  ReadNFC.swift
//  eWallet
//
//  Created by Ted Tan on 17/8/24.
//
import SwiftUI
import CoreNFC

class NFCConnectionManager: NSObject {
    var session: NFCNDEFReaderSession?

    func startSession() {
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        self.session?.begin()
    }
}

extension NFCConnectionManager: NFCNDEFReaderSessionDelegate {
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        debugPrint("NFC session become active======")
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error)
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                print("Type name format: \(record.typeNameFormat)")
                print("Payload: \(record.payload)")
                print("Type: \(record.type)")
                print("Identifier: \(record.identifier)")
            }
        }
    }
}





struct ReadNFC: View {
    @State private var nfcContent = ""

    var body: some View {
        VStack {
            Text("NFC Content: \(nfcContent)")
                .padding()
            Button("Read NFC") {
                startNFCReading()
            }
            .padding()
        }
        
    }

    
    
    
    
    
    
    private func startNFCReading() {
        let nfcSession = NFCNDEFReaderSession(
            delegate: NFCReaderDelegate(
                contentCallback: { content in
                    DispatchQueue.main.async {
                        self.nfcContent = content
                    }
                }
            ),
            queue: nil,
            invalidateAfterFirstRead: false
        )
        nfcSession.begin()
    }
}

class NFCReaderDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    private var contentCallback: ((String) -> Void)?

    init(contentCallback: @escaping (String) -> Void) {
        self.contentCallback = contentCallback
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let payloadString = String(data: record.payload, encoding: .utf8) {
                    contentCallback?(payloadString)
                }
            }
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error reading NFC: \(error.localizedDescription)")
    }
}
#Preview {
    ReadNFC()
}
