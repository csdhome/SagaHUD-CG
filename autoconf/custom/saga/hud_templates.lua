-- HUD SVG templates for SagaHUD
-- Dynamic values are injected via string.format: %s for strings, %d for numbers
local t = {}

t.targetReticle2 = [[<svg viewBox="-77.91 -57.847 135.41 86.458">
<text style="fill: rgb(204, 204, 204); font-family:SegoeUI,sans-serif; font-size: 30px; paint-order: fill; stroke: rgb(0, 0, 0); stroke-width: 2px; white-space: pre;" transform="matrix(0.955784, 0, 0, 1.03899, -3.444869, 2.252162)" x="-77.91" y="-30.551">%s</text>
<path style="fill: none; stroke: rgb(204, 204, 204);" d="M -77.91 -22.808 L 0.342 -22.808 L 57.5 28.611"/>
</svg>]]

t.speedBar = [[<svg viewBox="-29 -24 72 240">
<rect width="5" height="200" style="fill: rgb(255, 255, 255); fill-opacity: 0; paint-order: stroke; stroke: rgb(94, 94, 94);" transform="matrix(-1, 0, 0, -1, 0, 0)" x="-5" y="-200" bx:origin="0 0"/>
<rect width="5" height="%s" style="stroke: rgb(0,0,0); stroke-opacity: 0; fill: rgb(%s, %s, %s);" transform="matrix(-1, 0, 0, -1, 0, 0)" x="-5" y="-200" bx:origin="0 0"/>
<text style="white-space: pre; fill: #eee; font-family:%s, sans-serif;
	font-size:12px; paint-order: fill; stroke: #b80000; stroke-width: 3px; text-anchor: middle;"
	x="1.4" y="-2.6" transform="matrix(1.1, 0, 0, 1, 1, 0)">%s</text>
<text style="fill: rgb(200, 200, 200); font-family:%s, sans-serif; font-size: 12px; paint-order: fill; stroke: rgb(0, 0, 0); stroke-width: 2px; white-space: pre;" transform="matrix(0, -1, 1, 0, -102, 9.5)" x="-100" y="100">Speed</text>
<text style="fill: rgb(200, 200, 200); font-family:%s, sans-serif; font-size: 10px; paint-order: fill; stroke: rgb(0, 0, 0); stroke-width: 1px; white-space: pre;" x="6" y="5.5">%s</text>
</svg>]]

t.throttleBar = [[<svg viewBox="-29 -24 72 240">
<rect width="5" height="200" style="fill: rgb(255, 255, 255); fill-opacity: 0; paint-order: stroke; stroke: rgb(94, 94, 94);" transform="matrix(-1, 0, 0, -1, 0, 0)" x="-5" y="-200" bx:origin="0 0"/>
<rect width="5" height="%s" style="stroke: rgb(0,0,0); stroke-opacity: 0; fill: rgb(150, 150, 150);" transform="matrix(-1, 0, 0, -1, 0, 0)" x="-5" y="-200" bx:origin="0 0"/>
<text style="white-space: pre; fill: rgb(200, 200, 200); font-family:%s, sans-serif; font-size: 12px; paint-order: fill; stroke: #b80000; stroke-width: 2px; text-anchor: middle;" x="1.4" y="-2.6" transform="matrix(1.1, 0, 0, 1, 1, 0)">%s</text>
<text style="fill: rgb(200, 200, 200); font-family:%s, sans-serif; font-size: 14px; paint-order: fill; stroke: rgb(0, 0, 0); stroke-width: 2px; white-space: pre;" transform="matrix(0, -1, 1, 0, -102, 9.5)" x="-100" y="100">%s</text>
<text style="fill: rgb(200, 200, 200); font-family:%s, sans-serif; font-size: 10px; paint-order: fill; stroke: rgb(0, 0, 0); stroke-width: 1px; white-space: pre;" x="6" y="5.5">%s</text>
</svg>]]

t.altitudeBar = [[<svg viewBox="-39 -24 100 240">
<rect width="5" height="200" style="fill: rgb(255, 255, 255); fill-opacity: 0; paint-order: stroke; stroke: rgb(94, 94, 94);" transform="matrix(-1, 0, 0, -1, 0, 0)" x="-5" y="-200" bx:origin="0 0"/>
<rect width="5" height="%s" style="stroke: rgb(0,0,0); stroke-opacity: 0; fill: rgb(150, 150, 150);" transform="matrix(-1, 0, 0, -1, 0, 0)" x="-5" y="-200" bx:origin="0 0"/>
<text style="white-space: pre; fill: #eee; font-family:%s, sans-serif;
	font-size:12px; paint-order: fill; stroke: #b80000; stroke-width: 3px; text-anchor: middle;"
	x="2" y="-2.6" transform="matrix(1.1, 0, 0, 1, 1, 0)">%s</text>
<text style="fill: rgb(200, 200, 200); font-family:%s, sans-serif; font-size: 14px; paint-order: fill;
	stroke: rgb(0, 0, 0); stroke-width: 2px; white-space: pre;" transform="matrix(0, -1, 1, 0, -102, 9.5)" x="-100" y="100">Altitude</text>
<text style="fill: rgb(200, 200, 200); font-family:%s, sans-serif; font-size: 10px; paint-order: fill;
	stroke: rgb(0, 0, 0); stroke-width: 1px; white-space: pre;" x="15" y="8.5">%s</text>
</svg>]]

t.crosshair = [[
<div class="crosshair" style="position:absolute;left:%s%%;top:%s%%;margin-top:0em;margin-left:0em;">
<svg style="width:2vw;height:2vh;" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M23.6465 37.8683L24.0001 38.2218L24.3536 37.8683L26.3536 35.8684L26.5 35.7219V35.5148V26.5H35.5148H35.7219L35.8684 26.3536L37.8684 24.3536L38.2219 24L37.8684 23.6465L35.8684 21.6465L35.7219 21.5H35.5148H26.5V12.4852V12.2781L26.3536 12.1317L24.3536 10.1317L24.0001 9.77818L23.6465 10.1317L21.6465 12.1318L21.5 12.2782V12.4854V21.5H12.4854H12.2782L12.1318 21.6465L10.1318 23.6465L9.77824 24L10.1318 24.3536L12.1318 26.3536L12.2782 26.5H12.4854H21.5V35.5147V35.7218L21.6465 35.8682L23.6465 37.8683Z" fill="#00dd00" stroke="#333333"/>
</svg></div>]]

return t
