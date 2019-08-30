
IEEE **802.11** wireless computer networking standards

* Protocols for implementing **WLAN** (Wireless Local Area Network)
* Basis for the **Wi-Fi** (Wireless Fidelity) brand
* The standard is updated by means of amendments
  - Denoted by 802.11 followed by a non-capitalized letter, e.g. IEEE 802.11a
  - Cf. [list of amendments](https://en.wikipedia.org/wiki/IEEE_802.11#Standards_and_amendments)
* Widely used in the **2.4Ghz** and **5Ghz** radio frequencies
  - ISM bands: 2.400–2.500 GHz, and 4.915–5.825 GHz spectrum
  - Each spectrum is sub-divided into **channels** with a center frequency and bandwidth
  - Cf. [list of channels](https://en.wikipedia.org/wiki/List_of_WLAN_channels)

## Wireless Security 

Cf. [Wireless Security Measures](https://en.wikipedia.org/wiki/Wireless_security#Security_measures)

Protocols:

* **WEP** original encryption protocol superseded by WPA
* **WPA** (Wi-Fi Protected Access)
  - Introduced as an interim security enhancement over WEP
  - Designed to be deployed on existing devices as firmware upgrade
  - "WPA Personal" use a **PSK** (preshared key) for authentication
  - "WPA Enterprise" uses an authentication server to generate keys/certificates
  - Uses TKIP for encryption
* **WPA2**
  - Based on final 802.11i amendment (2004)
  - Uses a 256bit AES key for encryption
  - Support PSK, and EAP authentication methods using RADIUS servers

### EAP (Extensible Authentication Protocol)

Further improves WPA over the IEEE 802.1X standard

* Authentication framework based on RFC standards
* WPA[2,3] uses EAP as authentication mechanism

EAP type:

* EAP-TLS
* EAP-TTLS (supports other auth. protocols in a TLS tunnel)
* PEAP (encapsulates EAP in a TLS tunnel)
  - PKI base server certificate
  - EAP-MSCHAPv2 (authenticate to a Microsoft MS_CHAPv2 database)

