-- twister16
--
-- 16 ccs total
-- 4 in each bank
--
-- e1     midi channel
-- e2     cc1
-- e3     cc2
-- k1+e2  cc3
-- k1+e3  cc4
-- k2     bank down
-- k3     bank up

m = midi.connect(1)
bank = 1
bank_size = 4
bank_start = 0
cc = 1
cc_value = {}

params:add{
  type="number",
  id="midi_channel",
  name="midi channel",
  min=1,
  max=16,
  default=1
}

function init()
  for i=1,64 do
    cc_value[i] = 0
  end
end

function key(n,z)
  if n == 1 then
    shifted = z == 1
  elseif n == 2 and z == 1 then
    bank = util.clamp(bank - 1,1,4)
    bank_start = (bank-1)*bank_size
  elseif n == 3 and z == 1 then
    bank = util.clamp(bank + 1,1,4)
    bank_start = (bank-1)*bank_size
  end
  redraw()
end

function enc(n,d)
  if n > 1 then
    if shifted then
      cc = n+1+bank_start
    else
      cc = n-1+bank_start
    end
    cc_value[(cc)] = util.clamp(cc_value[(cc)] + d,0,127)
    m:cc((cc),cc_value[(cc)],params:get("midi_channel"))
  elseif n == 1 then
    params:delta("midi_channel",d)
  end
  redraw()
end

function redraw()
  screen.clear()
  screen.level(15)
  k = 0
  x = 0
  y = 0
  for i=0,3 do
    for j=1,7,2 do
      x = i*32
      y = j*5
      k = k+1
      screen.move(x,y)
      screen.text("cc"..k..":"..cc_value[k])
    end
  end
  
  screen.move(0,60)
  screen.text("bank: "..bank)
  screen.move(80,60)
  screen.text("midi ch: "..params:get("midi_channel"))
  screen.update()
end
