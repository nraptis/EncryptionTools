//
//  ContentView.swift
//  EncryptionTools
//
//  Created by Nicky Taylor on 11/1/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var verificationTool = VerificationTool()
    var body: some View {
        VStack {
            Spacer()
            testButtons
            TextField("Data To Encrypt", text: $verificationTool.plainText)
                .textFieldStyle(.roundedBorder)
            TextField("Data To Descrypt", text: $verificationTool.encryptedText)
                .textFieldStyle(.roundedBorder)
            HStack {
                Button {
                    verificationTool.encrypt()
                } label: {
                    HStack {
                        Spacer()
                        Text("Encrypt")
                            .padding(.all, 4.0)
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                Button {
                    verificationTool.decrypt()
                } label: {
                    HStack {
                        Spacer()
                        Text("Decrypt")
                            .padding(.all, 4.0)
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            Spacer()
        }
        .padding()
    }
    
    var testButtons: some View {
        HStack {
            Button {
                verificationTool.plainText = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-~0123456789!@#$%^&*[]{}<>()"
                verificationTool.encryptedText = ""
            } label: {
                HStack {
                    Spacer()
                    Text("Long String")
                        .padding(.all, 4.0)
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            Button {
                verificationTool.plainText = "abcdefghiuvwxyzABCDEFGHIJKLMNYZ012789"
                verificationTool.encryptedText = ""
            } label: {
                HStack {
                    Spacer()
                    Text("Medium String")
                        .padding(.all, 4.0)
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            Button {
                verificationTool.plainText = "abcdefghijklmnopqrstuvwxyz"
                verificationTool.encryptedText = ""
            } label: {
                HStack {
                    Spacer()
                    Text("Lowercase")
                        .padding(.all, 4.0)
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            Button {
                verificationTool.plainText = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                verificationTool.encryptedText = ""
            } label: {
                HStack {
                    Spacer()
                    Text("Uppercase")
                        .padding(.all, 4.0)
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            Button {
                verificationTool.plainText = "0123456789"
                verificationTool.encryptedText = ""
            } label: {
                HStack {
                    Spacer()
                    Text("Numbers")
                        .padding(.all, 4.0)
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
}
