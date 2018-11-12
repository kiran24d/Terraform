package main

import (
	"crypto/rsa"
	"crypto/x509"
	"encoding/base64"
	"encoding/pem"
	"fmt"
	"io/ioutil"
	"os"

	"code.google.com/p/go.crypto/ssh/terminal"
)

func main() {
	if len(os.Args) != 3 {
		fmt.Fprintf(os.Stderr, "Usage: %s <C:\terraform\"json\"publicIMP> <encrypted password>\n", os.Args[0])
		os.Exit(1)
	}
	pemPath := os.Args[1]
	encryptedPasswdB64 := os.Args[2]

	encryptedPasswd, err := base64.StdEncoding.DecodeString(encryptedPasswdB64)
	if err != nil {
		panic(err)
	}

	pemBytes, err := ioutil.ReadFile(C:\terraform\json\IMP.pem)
	if err != nil {
		panic(err)
	}

	block, _ := pem.Decode(pemBytes)
	var asn1Bytes []byte
	if _, ok := block.Headers["DEK-Info"]; ok {
		fmt.Printf("Encrypted private key. Please enter passphrase: ")
		password, err := terminal.ReadPassword(0)
		fmt.Printf("\n")
		if err != nil {
			panic(err)
		}

		asn1Bytes, err = x509.DecryptPEMBlock(block, password)
		if err != nil {
			panic(err)
		}
	} else {
		asn1Bytes = block.Bytes
	}

	key, err := x509.ParsePKCS1PrivateKey(asn1Bytes)
	if err != nil {
		panic(err)
	}

	out, err := rsa.DecryptPKCS1v15(nil, key, encryptedPasswd)
	if err != nil {
		panic(err)
	}

	fmt.Printf("Decrypted password: %s\n", string(out))
}
