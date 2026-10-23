// Lenovo Zhaoyang K3-IML, CQCN42WW: use the OEM Radeon 630 power sequence.
// Pair with the DSDT-only root _WAK -> XWAK rename in config.plist.
// GPIO values describe the OEM power-enable signal, not measured rail voltage.
DefinitionBlock ("", "SSDT", 2, "K3IML", "DGPUOFF", 0x00000001)
{
    External (\_SB.PCI0.RP05.PEGP._OFF, MethodObj)
    External (\_SB.PCI0.SGPI, MethodObj)
    External (\_SB.PCI0.GFX0.MACO, IntObj)
    External (\_SB.GGOV, MethodObj)
    External (\RPIN, FieldUnitObj)
    External (\SGGP, FieldUnitObj)
    External (\PWE0, FieldUnitObj)
    External (\PWG0, FieldUnitObj)
    External (\PWA0, FieldUnitObj)
    External (\XWAK, MethodObj)

    Scope (\_SB)
    {
        Device (DGPO)
        {
            Name (_HID, "RMD10000")
            Name (_UID, One)
            Name (CALL, Zero)
            Name (DONE, Zero)
            Name (PBEF, 0xFF)
            Name (PAFT, 0xFF)

            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Return (Zero)
            }

            // Reuse the OEM polarity-aware GPIO reader only on its GPIO path.
            // 0 = power enable inactive, 1 = active, 0xFF = not available.
            Method (GPST, 0, Serialized)
            {
                If (CondRefOf (\_SB.PCI0.SGPI) && CondRefOf (\_SB.GGOV))
                {
                    If ((\SGGP == One) && (\_SB.PCI0.GFX0.MACO == Zero))
                    {
                        Return (\_SB.PCI0.SGPI (\SGGP, \PWE0, \PWG0, \PWA0))
                    }
                }
                Return (0xFF)
            }

            Method (POFF, 0, Serialized)
            {
                If (_OSI ("Darwin"))
                {
                    If (CondRefOf (\_SB.PCI0.RP05.PEGP._OFF))
                    {
                        If (\RPIN == 0x04)
                        {
                            PBEF = GPST ()
                            CALL++
                            // HGOF retains the OEM presence and power checks,
                            // link transition, reset timing and GPIO polarity.
                            \_SB.PCI0.RP05.PEGP._OFF ()
                            DONE++
                            PAFT = GPST ()
                        }
                    }
                }
            }

            Method (_INI, 0, NotSerialized)
            {
                POFF ()
            }

            // IORegistry properties are snapshots taken when _DSM is evaluated.
            Method (_DSM, 4, Serialized)
            {
                If (Arg2 == Zero)
                {
                    Return (Buffer (One) { 0x03 })
                }
                If (Arg2 == One)
                {
                    Local0 = Package (0x0A)
                    {
                        "dgpu-off-calls", Zero,
                        "dgpu-off-returns", Zero,
                        "dgpu-power-before", Zero,
                        "dgpu-power-after", Zero,
                        "dgpu-power-at-dsm", Zero
                    }
                    Local0 [One] = CALL
                    Local0 [0x03] = DONE
                    Local0 [0x05] = PBEF
                    Local0 [0x07] = PAFT
                    Local0 [0x09] = GPST ()
                    Return (Local0)
                }
                Return (Buffer (One) { 0x00 })
            }
        }
    }

    // Firmware may restore discrete graphics during sleep. Run its complete
    // wake method first, preserve its return value, then request power off.
    If (CondRefOf (\XWAK))
    {
        Method (\_WAK, 1, Serialized)
        {
            Local0 = \XWAK (Arg0)
            \_SB.DGPO.POFF ()
            Return (Local0)
        }
    }
}
