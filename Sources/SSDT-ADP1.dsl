// K3-IML: keep the logical AC adapter discoverable when booting on battery.
// Pair with the ADP1-only _STA -> XSTA rename in config.plist.
// _PSR and all battery/EC methods remain owned by the OEM firmware.
DefinitionBlock ("", "SSDT", 2, "K3IML", "ADP1STA", 0x00000001)
{
    External (\_SB.PCI0.LPCB.H_EC.ADP1, DeviceObj)
    External (\_SB.PCI0.LPCB.H_EC.ADP1.XSTA, MethodObj)

    If (CondRefOf (\_SB.PCI0.LPCB.H_EC.ADP1.XSTA))
    {
        Scope (\_SB.PCI0.LPCB.H_EC.ADP1)
        {
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }

                Return (XSTA ())
            }
        }
    }
}
