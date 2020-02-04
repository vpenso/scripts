# OLED (Organic Light Emitting Diode)

Use organic materials that **emit light when electricity is applied**

* ...rather then blocking light like LCDs
* Series of organic thin films between two conductors
* Emissive displays that do not require backlight, or color filters
* Only an “on” pixel consumes power

Improvements over LCDs:

* Ultra-thin form factor: Plastic, organic layers of an OLED are thinner,
  lighter and more flexible than the crystalline layers in an LED
* Because the light-emitting layers of an OLED are lighter:
  - Substrates can be plastic rather than the glass used for LEDs
  - Substrate of an OLED can be flexible (fold, roll, stretch) instead of rigid
* Lower power consumption
* Better durability (broader temperature range)
* Long-lasting lifetime, up to 55.000 hours
* Improved resolution up to <5 micrometer pixel size
* Improved display refresh rates between 1 to 10 microseconds
* OLEDs are brighter than LEDs, with better contrast
* Large fields of view, about 170 degrees
* Wider color range

Disadvantages overt LCDs:

* (currently) More expensive manufacturing costs
* Over time, moisture can react with the organic layers, cause degradation and
  defects in an OLED display
* Harder to see in direct sun-light

## Manufacturing

Vacuum Deposition or Vacuum Thermal Evaporation (VTE)

* Vacuum evaporation of small organic molecules onto a substrate
* Evaporation through a slow heating process...
* ...followed by a thin film condensing onto the cooled substrate
* Inefficient, expensive, limited up to 15" diameter
* Crystallization process shortens lifespan and reliability

Organic Vapor Phase Deposition (OVPD)

* Use of a carrier gas to transfer films of organic material... 
* ... onto substrate in a hot-walled, low-pressure chamber
* Better control film thickness, lower material cost

Polymer OLEDs, Inkjet Printing

* OLEDs sprayed onto substrate through inkjet printing...
* ...under ambient conditions
* Low cost, deposit of multiple layers simultaneously
* Fabrication of large screen sizes
* Problems
   - Substrate surface properties affect uniformity of the film thickness
   - Layer shift due to drying and evaporation process

## Types

**PMOLED** (passive matrix OLED)

- Cheaper manufacturing compared to other OLED types
- Large driving current to achieve adequate average brightness...
- ...limits display size (<3"), resolution by max. input voltage
- ...increased power dissipation, excess flicker, shortened lifespan
- Most efficient for text (most pixels off)
- Still more power efficient the LCDs

External circuitry control each row in the display sequentially:

- Strips of cathode, organic layers and strips of anode
- Anode strips are arranged perpendicular to the cathode strips
- Intersections of the cathode/anode makes the pixels (light is emitted)
- External circuitry applies current to selected strips of anode and cathode
- Brightness of pixels proportional to driving current

**AMOLED** (active matrix OLED)

- Use (active-matrix) TFT array with storage capacitor 
- Consume less power than PMOLEDs (internal TFT more efficient)
- Faster refresh rate (suitable for video)
- Efficient enough to support larger high-resolution displays

Internal TFT array circuitry determines which pixels get turned on:

- Full layers of cathode, organic molecules and anode
- Anode layer overlays a thin film transistor (TFT) array forming a matrix
