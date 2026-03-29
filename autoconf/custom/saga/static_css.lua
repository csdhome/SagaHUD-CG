-- Static CSS templates for SagaHUD
-- Placeholders: %HUE%, %S3%, %S4%, %S5%, %SCALE%, %SCALEP%
local css = {}

css.menuCssTemplate = [[
.mainMenu {font-size:%SCALE%px;font-family: 'Montserrat'}
.mainMenu text { alignment-baseline: middle;text-shadow: none;stroke-width: 0;white-space: pre;fill: hsl(0,0%,95%);text-anchor: start}
.menuOption text {alignment-baseline: central}
text.valueText {text-anchor: end}
.mainMenu path {fill:hsla(%HUE%,%S5%%,80%,0.5)} [data-hover=true] text {fill:hsl(%HUE%,%S5%%,100%)}
[data-hover=true] rect {fill:hsla(%HUE%,%S5%%,50%,0.5)}
[data-hover=true] path {fill:hsla(%HUE%,%S5%%,100%,0.7)}
[data-hover=true] rect.separator {fill: hsl(0,0%,85%)}
/* active */
[data-active=true] rect.separator {fill: hsl(0,0%,100%)}
/* active hover */
[data-active=true][data-hover=true] rect{}
rect.inputHold {fill:hsl(0,0%,75%) }
text.outlined {text-shadow:0 0 1vh black}
rect.separator {fill:hsl(0,0%,100%)}
rect.checkBox {fill:hsl(0,0%,70%)}
rect.checkBox.checked {fill:hsl(0,0%,100%)}
rect.editableBg {fill:hsla(0,0%,0%,0.3)}
rect.editableGlyph {fill:hsl(0,0%,95%)}
.menuLegendGlyph {overflow:visible}
text.menuLegendText {fill:hsl(0,0%,88%)}
text.menuLegendKey {fill:hsl(58,89%,44%);text-anchor:end}
path.menuLegendKey {fill:hsl(0,0%,95%)}
.menuLegend[data-active=true] text, .menuLegend[data-active=true] path {fill:hsl(0,0%,100%)}
]]

css.widgetCssTemplate = [[
.widget {
    position: absolute;
    white-space: pre;
    font-size: %SCALE%px;
    font-family: 'Montserrat';
    color: hsl(0,0%,95%);
    background-color: hsla(0,0%,0%,0.2);
    border:0.1vh solid hsl(0,0%,95%);
    text-shadow: 0.2vh 0.2vh 1vh black;
    padding: %SCALEP%px;
}
.widget.alert {border-color: hsl(16,100%,50%)}
.radarRow {display: relative;height: 1.2vh}
.radarText {position: absolute;overflow: hidden}
.coreInfo {text-align: center}
.dottext {position:absolute; width:6vh; height:6vh; left:-6vh; top:-6vh; border-radius:1vh}
.dot {position:absolute; width:3vh; height:3vh; left:-1.5vh; top:-1.5vh; border-radius:1vh}
.planets {position:absolute; width:2vh; height:2vh; left:-1vh; top:-1vh; border-radius:1vh}
.ptext {position:absolute; width:3vh; height:3vh; left:-1.5vh; top:3vh; border-radius:1vh}
.mtext {position:absolute; width:3vh; height:3vh; left:-1.5vh; top:3vh; border-radius:1vh}
.collision {position:absolute; top:94vh; right:80vw; width:18vw; padding-left: 1vh; padding-top: 1vh; padding-right: 1vh; padding-bottom: 1vh; border:0.1vh; border-style: solid; border-color: orangered}
.radar1 {position:absolute; top:83vh; right:25vw; width:12vw; padding-left: 1vh; padding-right: 1vh; padding-top: 1vh; padding-bottom: 1vh; border:0.1vh; border-style: solid; border-color: ivory}
.radar2 {position:absolute; top:83vh; right:38vw; width:12vw; padding-left: 1vh; padding-right: 1vh; padding-top: 1vh; padding-bottom: 1vh; border:0.1vh; border-style: solid; border-color: ivory}
.radar3 {position:absolute; top:83vh; right:51vw; width:12vw; padding-left: 1vh; padding-right: 1vh; padding-top: 1vh; padding-bottom: 1vh; border:0.1vh; border-style: solid; border-color: ivory}
.speedBar{position:absolute; width:11.5vh; height:11.5vh; left:30vh; top:-18vh; border-radius:1vh;}
.throttleBar{position:absolute; width:11.5vh; height:11.5vh; left:40vh; top:-18vh; border-radius:1vh;}
.altBar{position:absolute; width:14vh; height:32vh; left:-40vh; top:-16vh; border-radius:1vh;}
.svg {background: #eee;}

.atmoAlert	{position:absolute; top:74vh;	right:60vw;	width:10vw; padding:0.2vh; border:0.2vh;
    font-size: 1vh;color: ivory; text-shadow:0.2vh 0.2vh 1vh black;}
.apAlert	{position:absolute; top:76vh;	left:44vw;	width:10vw; padding: 1vh;
    border:0.2vh; border-style: solid; border-color: orangered}
.brakeAlert	{position:absolute; top:73vh;	left:44vw;	width:10vw; padding: 1vh}
]]

return css
