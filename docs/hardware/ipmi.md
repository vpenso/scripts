The term **Platform Management** is used to refer to the monitoring and control functions that are built in to the platform hardware and primarily used for the purpose of monitoring the health of a computer system. _Intelligent Platform Management Interface (IPMI)_ defines standardized, abstracted interfaces to the platform management subsystem. The term _Intelligent Platform Management (IPM)_ refers to autonomous monitoring and recovery features implemented directly in platform management hardware and firmware, which is **independent of the main processors, BIOS, and operating system**.

→ [IPMI Specification v2 rev1.1](http://www.intel.com/content/dam/www/public/us/en/documents/product-briefs/ipmi-second-gen-interface-spec-v2-rev1-1.pdf)

At the heart of the IPMI architecture is a micro controller called the _Baseboard Management Controller (BMC)_ providing the interface between system management software and the platform management hardware.Typically BMCs register with the BIOS after POST (Power-On Self-Test), which enables system administrators to use a dedicated _BMC Network Configuration_ section in the BIOS menu. Many BMCs have a dedicated **out-of-band** Ethernet interface, and support **side-band** Ethernet connections using the main-board network interface utilizing the _System Management Bus_ (SMBus) also. 

SMBus (also known as _Intelligent Platform Management Bus/Bridge (IPMB)_)  interfaces are common on power and peripheral control chips, allowing IPMI management and control. The interface also provides access to serial nonvolatile storage devices.

# Access

BMCs may support access by following methods, depending on the vendor:

- Web-interface HTTP(S)
- Secure command line interface (SSH)
- Remote KVM ("keyboard, video and mouse") over IP (graphic)
- Remote _Serial Port Console Redirection_ over LAN (SOL) (text only) 

## Tools

    » apt install openipmi freeipmi-tools ipmitool

**OpenIPMI** implements device drivers that go into the Linux kernel, and a user-level library that provides a higher-level abstraction of IPMI and generic services that can be used on any operation system.  

Kernel 3.10 and later will auto load OpenIPMI modules

    » lsmod | grep ipmi
    ipmi_watchdog          21915  0 
    ipmi_si                48709  2 
    ipmi_poweroff          13197  0 
    ipmi_devintf           17053  0 
    ipmi_msghandler        39917  4 ipmi_devintf,ipmi_poweroff,ipmi_watchdog,ipmi_si

**IPMItool** and GNU **FreeIPMI** provide command-line programs that interfaces with an IPMI using IPMI-over-LAN or the Linux driver and library from OpenIPMI.



## Browser

Most IPMI web-interfaces provide access to console via an Java applet, before you can use this **remote console** install:

    » apt install openjdk-7-jre icedtea-plugin icedtea-netx

- HTTP proxy settings can prevent the download from JAR archives in your browser!
- Eventually configure Firefox to start JNLP files with `/usr/bin/javaws` (by selecting it manually from the open-file dialog). 

## Serial Over LAN

Connects to the serial over LAN (SOL) console with:

    » ipmitool -I lanplus -U ADMIN -a sol activate -H <ip>
    » ipmi-console -u ADMIN -h <ip>

`~.` to exit the console session.

# Configuration

    » ipmitool mc info
    […]
    Firmware Revision         : 1.70
    IPMI Version              : 2.0
    […]

Belows command will print the network settings:

    » ipmitool lan print | grep -e 'IP Address' -e 'MAC Address' -e 'Gateway IP'
    IP Address Source       : DHCP Address
    IP Address              : 10.6.4.212
    MAC Address             : 10:c3:7b:e6:f9:ee
    Default Gateway IP      : 10.6.0.1
    Backup Gateway IP       : 0.0.0.0

Network configuration can be set by <kbd>ipmitool</kbd>:

    » ipmitool lan set 1 ipsrc static
    » ipmitool lan set 1 ipaddr 10.1.2.3
    » ipmitool lan set 1 netmask 255.255.255.0
    » ipmitool lan set 1 defgw ipaddr 10.1.0.1

# Operation

## BMC Reset

Without management access a BMC reset is only possible by removing the power plugs.

Otherwise use the web-interface or <kbd>ipmitool</kbd>:

    » ipmitool mc reset cold
    […]
 

## Power Management

Power management with <kbd>ipmitool</kbd>, `cycle` is equivalent to power-off, wait 1 second, and power-on, while `reset` refers to cold reset. 

    » ipmitool chassis status
    System Power         : on
    […]
    » ipmitool chassis power off|on
    » ipmitool chassis reset|cycle


<kbd>ipmipower</kbd> controls power state of nodes via the service module

    » nodeset-ipmi() { /usr/sbin/ipmipower -u ADMIN -h $(NODES).mng.devops.test $@ }
    » nodeset-ipmi -P -s
    Password: 
    sm-lxbk0001.itm.gsi.de: on
    sm-lxbk0004.itm.gsi.de: on
    […]

| Options        |     Description                           |
|----------------|-------------------------------------------|
| `-P`           | Prompt for a login password               |
| `-p password`  | Set a login password (non-interactive)    |
| `-[n,f,c,r,s]` | o(n) – of(f) – (c)ycle – (r)eset – (s)tat |

Search for nodes in certain power state and fold a new node set

    » nodeset-ipmi -s -p […] | grep off | cut -d. -f1 | cut -d- -f2 | nodeset -f
    lxbk[0012-0043,0067,0102-0106]


# Sensors

Sensors collect data about **temperatures and voltages, fan status**. Sensors are classified according to the type of readings they provide and/or the type of events they generate. A sensor can return either an analog or discrete reading. Sensor events can be discrete or threshold-based. Sensors and their events are represented using **numeric codes** defined in the IPMI specification. Print a list of sensors including their **sensor number** with <kbd>ipmi-sensors</kbd>

~~~
» ipmi-sensors -vv | grep -e 'Record ID' -e 'ID String' -e 'Sensor Number'
[…]
ID String: System Temp
Sensor Number: 3
Record ID: 205
[…]
~~~

Show a specific sensor record with option `--record-ids=`:

~~~
» ipmi-sensors --record-ids=205
ID  | Name        | Type        | Reading    | Units | Event
205 | System Temp | Temperature | 26.00      | C     | 'OK'

~~~


## Threshold 

Threshold are analog temperature values from sensors with corresponding boundaries. Six distinguished thresholds are configurable used to individually emit an event eventually. The command <kbd>ipmitool</kbd> provides an overview of the thresholds:

~~~
» ipmi-sensors --output-sensor-thresholds --record-ids=205
[…]
» ipmi-sensors -t temperature --output-sensor-thresholds
[…]
» ipmitool sensor get "System Temp"
Locating sensor record...
Sensor ID              : System Temp (0xb)
 Entity ID             : 7.1
 Sensor Type (Analog)  : Temperature
 Sensor Reading        : 30 (+/- 0) degrees C
 Status                : ok
 Lower Non-Recoverable : -9.000
 Lower Critical        : -7.000
 Lower Non-Critical    : -5.000
 Upper Non-Critical    : 60.000
 Upper Critical        : 65.000
 Upper Non-Recoverable : 80.000
 Assertion Events      : 
 Assertions Enabled    : lcr- lnr- ucr+ unr+ 
 Deassertions Enabled  : lcr- lnr- ucr+ unr+
~~~

`ipmitool` can be used to set the thresholds also:

~~~
» ipmitool sensor thresh 'System Temp' upper 60 65 80
Locating sensor record 'System Temp'...
Setting sensor "System Temp" Upper Non-Critical threshold to 60.000
Setting sensor "System Temp" Upper Critical threshold to 65.000
Setting sensor "System Temp" Upper Non-Recoverable threshold to 80.000
~~~
~~~
» ipmitool sensor thresh 'System Temp' ucr 59
Locating sensor record 'System Temp'...
Setting sensor "System Temp" Upper Critical threshold to 59.000
~~~

## Events

The command <kbd>ipmi-sensors-config</kbd> shows the conditions emitting an event:

~~~
» ipmi-sensors-config --listsections
[…]
» ipmi-sensors-config --checkout --section 205_System_Temp | grep -v '#'
[…]
Enable_All_Event_Messages                                                   Yes
Enable_Scanning_On_This_Sensor                                              Yes
Enable_Assertion_Event_Lower_Critical_Going_Low                             Yes
Enable_Assertion_Event_Lower_Non_Recoverable_Going_Low                      Yes
Enable_Assertion_Event_Upper_Critical_Going_High                            Yes
Enable_Assertion_Event_Upper_Non_Recoverable_Going_High                     Yes
Enable_Deassertion_Event_Lower_Critical_Going_Low                           Yes
Enable_Deassertion_Event_Lower_Non_Recoverable_Going_Low                    Yes
Enable_Deassertion_Event_Upper_Critical_Going_High                          Yes
Enable_Deassertion_Event_Upper_Non_Recoverable_Going_High                   Yes
[…]
~~~

# Logs

Event messages are sent by the BMC when significant or critical system management events are detected. Critical events should be captured by _System Event Log_ (SEL), if they are required for ‘post-mortem’ analysis or autonomous system response (e.g. power off). Critical events include:

- Temperature threshold exceeded
- Voltage threshold exceeded
- Power or fan fault
- Interrupts/signals that affect system operation (NMIs, PCI PERR (parity error), and SERR (system error)
- Events that impact system data integrity e.g. uncorrectable ECC errors, system security (chassis intrusion)

# Filters

_Platform Event Filtering_ (PEF) is a mechanism to take selected actions on event messages sent by the BMC. Event filtering is independent of event logging with SEL.  The _Event Filter Table_ configures system actions to perform on a given event like power-off or system reset. The specification recommends to support at least 16 entries. A subset of these entries should be pre-configured for common system failures, e.g. the system running to hot. The _Alert Policy Table_ configures event messages forwarding to a given destination, typically another service in the LAN.

List the active event filters with <kbd>ipmitool</kbd>:

~~~
» ipmitool pef list | grep ' active'
 16 | active | 0x11 | Temperature | 3 | Critical | OEM | Any | Power-off
~~~

List all sections of PEF with <kbd>ipmi-pef-config</kbd>:

~~~
» ipmi-pef-config --listsections
Community_String
Lan_Alert_Destination_0
[…]
Alert_String_0
Alert_String_1
Alert_String_2
Alert_Policy_1
[…]
Event_Filter_14
Event_Filter_15
Event_Filter_16
~~~

Limit the output to a specific event with option `--section`. Note that `0xFF` matches any possible source, cf. IPMI Specification 17.1:

~~~
ipmi-pef-config --checkout --section=Event_Filter_16 | grep -v '#'
Section Event_Filter_16
  Filter_Type                                   Software_Configurable
  Enable_Filter                                 Yes
  Event_Filter_Action_Alert                     No
  Event_Filter_Action_Power_Off                 Yes
  Event_Filter_Action_Reset                     No
  Event_Filter_Action_Power_Cycle               No
  Event_Filter_Action_Oem                       No
  Event_Filter_Action_Diagnostic_Interrupt      No
  Event_Filter_Action_Group_Control_Operation   No
  Alert_Policy_Number                           0
  Group_Control_Selector                        0
  Event_Severity                                Critical
  Generator_Id_Byte_1                           0xFF
  Generator_Id_Byte_2                           0xFF
  Sensor_Type                                   Temperature
  Sensor_Number                                 0x03
  Event_Trigger                                 0xFF
  Event_Data1_Offset_Mask                       0xFFFF
  Event_Data1_AND_Mask                          0x00
  Event_Data1_Compare1                          0xFF
  Event_Data1_Compare2                          0x00
  Event_Data2_AND_Mask                          0x00
  Event_Data2_Compare1                          0xFF
  Event_Data2_Compare2                          0x00
  Event_Data3_AND_Mask                          0x00
  Event_Data3_Compare1                          0xFF
  Event_Data3_Compare2                          0x00
EndSection
~~~

Retrieve the currently **running configuration** from the BMC with the command option `--checkout`. Configuration **modifications** can be loaded into the BMC with option `--commit --filename=PATH` providing a file argument.

~~~
ipmi-pef-config --checkout > ipmi-pef.conf
ipmi-pef-config --commit --filename=ipmi-pef.conf
~~~

Single **event configuration** is possible with the options `--commit --key-pair="SECTION:KEY=VALUE"`, where section name and configuration key are delimited by a double point: 

~~~
ipmi-pef-config -c -e Event_Filter_16:Sensor_Type=Temperature
ipmi-pef-config -c -e Event_Filter_16:Event_Severity=Critical
ipmi-pef-config -c -e Event_Filter_16:Event_Filter_Action_Power_Off=yes
ipmi-pef-config -c -e Event_Filter_16:Enable_Filter=yes
~~~
~~~
ipmi-pef-config -c -e Event_Filter_16:Generator_Id_Byte_1=0xFF
ipmi-pef-config -c -e Event_Filter_16:Generator_Id_Byte_2=0xFF
ipmi-pef-config -c -e Event_Filter_16:Sensor_Number=0xFF
ipmi-pef-config -c -e Event_Filter_16:Event_Trigger=0xFF
ipmi-pef-config -c -e Event_Filter_16:Event_Data1_Offset_Mask=0xFFFF
ipmi-pef-config -c -e Event_Filter_16:Event_Data1_Compare1=0xFF
ipmi-pef-config -c -e Event_Filter_16:Event_Data2_Compare1=0xFF
ipmi-pef-config -c -e Event_Filter_16:Event_Data3_Compare1=0xFF
~~~


