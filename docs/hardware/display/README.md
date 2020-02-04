Physiological aspect of the human eye:

* Visual field: approx. 200°, 120° binocular overlap
* Retinal resolution 0.3 to 0.7 arc minutes (depends on task/luminance)
* Temporal resolution: approx 50Hz (increases with luminance)
* Three types of photoreceptors:
  - Blur (450nm +/-30)
  - Green (550nm +/-40)
  - Red (600nm +/-35)

# Displays

Display device is an output device to present information.

Electronic visual display (informally screen) technologies:

* **CRT** (cathode ray tube) 
* Segment display
* **LCD** (liquid crystal display)
  - **TFT** (thin-film transistor) LCD 
  - LCD with LED backlit
* LED (light-emitting diode)
  - **OLED** (organic light-emitting diode display)
  - AMOLED (active-matrix organic light-emitting diode)
* Plasma (plasma display panel)
* QLED (quantum dot LED)

Displays emitting light called **active** displays. Displays modulating
available light (reflection/transmission) called **passive** display.

## LCD (Liquid Crystal Display)

* Works by **adjusting the amount of light blocked**
* Array of liquid crystal segments (containing organic molecules)
  - Organized in a random pattern when not electric field is applied
  - Within an electric field crystals align perpendicular to a light source
  - Crystals "gate" the amount of light that can pass through
* A light source - **backlight** - needs to drive light through the crystals
* **TFT** type of an LCD with a thin film transistor attached to each pixel
  - Amplifies each pixel (higher contrast ratio)
  - Pixel hold electrical state
  - Pixel more rapidly switched (faster response time (25ms))

**Color filters** allow the generation of colors (RGB) at a segment:

- Three segments required to generate a real world color
- Light passes individually through red/grenn/blue filter segments
- These segments for a group, **RGB pixel**

I.e. a 320x240 RGB display is formed by 960 columns and 240 rows 

## OLED (Organic Light Emitting Diode)

Use organic materials that **emit light when electricity is applied**

* ...rather then blocking light like LCDs
* Series of organic thin films between two conductors
* Emissive displays that do not require backlight, or color filters

Improvements over LCDs:

* Ultra-thin form factor
* Lower power consumption
* Better durability (broader temperature range)
* Faster refresh rates
* Improved image quality
* Better contrast
* Higher brightness
* Wider viewing angle
* Wider color range
* Can be...
  - Transparent
  - Flexible
  - Foldable
  - Rollable
  - Sretchable

### Driving Method:

**PMOLED** (passive matrix OLED)

- Control each row in the display sequentially (one at a time)
- No (active) storage capacitor
- Limits in size & resolution by max. input voltage (typical <3")
- Cheap fabrication compared to AMOLED
- Lower lifetime

**AMOLED** (active matrix OLED)

- Use (active-matrix) TFT array with storage capacitor 
- Less power then PMOLEDs
- Faster refresh rate
- Supports larger high-resolution displays

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
