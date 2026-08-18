emu.wait(0.5)
local m = manager.machine
for tag,port in pairs(m.ioport.ports) do
  if tag:find("row") then
    for fname,field in pairs(port.fields) do
      if field.name == "Esc" or fname == "Esc" then
        -- scancode = row*16 + bit_index
        local mask = field.mask
        local bit = 0
        local mm = mask
        while mm > 1 do mm = mm >> 1; bit = bit + 1 end
        local rownum = tonumber(tag:match("row_(%d)"))
        print(string.format("ESC-FIELD tag=%s name=%s mask=0x%04x bit=%d scancode=%d",
              tag, field.name, mask, bit, rownum*16+bit))
      end
    end
  end
end
m:exit()
