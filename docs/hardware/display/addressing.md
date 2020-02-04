## Addressing Scheme

Three different addressing schemes for display devices:

* **Direct**
  - Individual control signals to each pixel
  - `m×n` pixels, require `m×n` control signals (considered inefficient)
* **Raster**
  - Scanning across display in sequence
  - Modulating control signal to activate each pixel
  - Pixels fade-out until the scan visits that pixel again 
* **Vector** displays
  - Display line by line, specified by endpoints
  - Directly control the electron beam of a CRT (cathode ray tube)
  - Periodical refresh required
* **Matrix**
  - Control signals only to the rows and columns
  - `m×n` pixels, require `m+n` control signals
  - Active matrix: external capacitor maintain the state of the cell
  - Passive matrix: cell itself bistable, no additional capacitor
