#!/bin/bash

# I exported the s/mime key from the apple certificate store
# as .p12 file which contains the public and the secret key

# Convert the p12 format to pem format
openssl pkcs12 -in fritz-sec.p12 -out fritz.pem -legacy

# Sign the unsigned mobileconfig file with the s/mime key
openssl smime -sign -in tha-email.mobileconfig -out tha-email-signed.mobileconfig -outform der -nodetach  -signer fritz.pem 

# The brew openssl version has no access to the macos trusted keys
# Export the GEANT Personal CA 4.pem and the USERTrust RSA Certification Authority.pem to the cert directory
# Then rehash with

openssl rehash cert

# Verify the signed message
/usr/bin/openssl smime -verify -in tha-email-signed.mobileconfig -signer fritz-pub.cer -inform der
openssl smime -verify -in tha-email-signed.mobileconfig -signer fritz-pub.cer -inform der -CApath cert