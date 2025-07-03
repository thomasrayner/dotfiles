table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-Generic_AB13X_USB_Audio_20210726905926-00.analog-stereo" },
    },
  },
  apply_properties = {
    ["node.description"] = "Desk Speakers",
  },
})

table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-Generic_AB13X_USB_Audio_20210726905926-00.2.analog-stereo" },
    },
  },
  apply_properties = {
    ["node.description"] = "Earbuds",
  },
})
