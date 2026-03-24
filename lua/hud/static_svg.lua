HUD.staticSVG = {
    categoryIndicator = '<path d="M0,0 L0,100 L100,50 Z"/>',
    upKey = '<path class="menuLegendKey" d="M50,0 L0,100 L100,100 Z"/>',
    downKey = '<path class="menuLegendKey" d="M0,0 L100,0 L50,100 Z"/>',
    rightKey = '<path class="menuLegendKey" d="M0,0 L0,100 L100,50 Z"/>',
    leftKey = '<path class="menuLegendKey" d="M0,50 L100,100 L100,0 Z"/>',
    upDownKey = '<path class="menuLegendKey" d="M0,0 L50,100 L-50,100 Z"/><path class="menuLegendKey" d="M50,0 L150,0 L100,100 Z"/>',
    checkBoxChecked = '<rect class="checkBox checked" width="100" height="100" y="0"/>',
    checkBoxUnchecked = '<rect class="checkBox" width="100" height="100" y="0"/>',
    editableBg = '<rect class="editableBg" width="100" height="100"/>',
    editableGlyph = '<rect class="editableGlyph" width="80" height="15" x="10" y="75"/>',
    progradeReticle = [[
        <svg viewBox="0 0 100 100">
        <circle style="stroke-width: 4px; stroke: rgb(20, 220, 40); fill: none;" cx="75" cy="75" r="33.333" transform="matrix(1, 0, 0, 0.999999, -24.999976, -24.999961)" bx:origin="0.331 0.224"/>
        <path style="fill: rgb(46, 139, 87); stroke-width: 4px; stroke: rgb(20, 220, 40);" d="M 83.333 50 L 100 50" bx:origin="-2.677 0"/>
        <path style="fill: rgb(46, 139, 87); stroke-width: 4px; stroke: rgb(20, 220, 40);" d="M 60.767 50 L 77.433 50" transform="matrix(-1, 0, 0, -1, 77.435763, 100.000003)" bx:origin="-1.323 0"/>
        <path style="fill: rgb(46, 139, 87); stroke-width: 4px; stroke: rgb(20, 220, 40);" d="M 101.733 31.6 L 118.4 31.6" transform="matrix(0, 1, -1, 0, 81.598635, -18.398635)" bx:origin="-3.104 0"/>
        <path style="fill: rgb(46, 139, 87); stroke-width: 4px; stroke: rgb(20, 220, 40);" d="M 64.933 31.6 L 81.6 31.6" transform="matrix(0, -1, 1, 0, 18.399367, 81.599368)" bx:origin="-0.896 0"/>
        <circle style="fill: rgb(46, 139, 87); fill-opacity: 0; stroke: rgb(20, 220, 40); stroke-width: 2px;" cx="50" cy="50" r="2.5" bx:origin="0.5 0.5"/>
        </svg>
    ]],
    retrogradeReticle = [[
        <svg viewBox="125 125 150 150">
        <path style="fill: rgb(46, 139, 87); stroke-width: 4px; stroke: rgb(20, 220, 40);" d="M 150 150 L 250 250" bx:origin="0.5 0.5"/>
        <path style="fill: rgb(46, 139, 87); stroke-width: 4px; stroke: rgb(20, 220, 40);" d="M 150 150 L 250 250" transform="matrix(0, 1, -1, 0, 400.000012, 0)" bx:origin="0.5 0.5"/>
        <circle style="stroke-width: 4px; stroke: rgb(20, 220, 40); fill: none;" cx="200" cy="200" r="50"/>
        <path style="fill: rgb(46, 139, 87); stroke-width: 4px; stroke: rgb(20, 220, 40);" d="M 250 200 L 275 200"/>
        <path style="fill: rgb(46, 139, 87); stroke-width: 4px; stroke: rgb(20, 220, 40);" d="M 125 200 L 150 200" transform="matrix(-1, 0, 0, -1, 275.000008, 400.000012)"/>
        <path style="fill: rgb(46, 139, 87); stroke-width: 4px; stroke: rgb(20, 220, 40);" d="M 249.725 200.275 L 274.725 200.275" transform="matrix(0, 1, -1, 0, 400.275006, 0.274988)" bx:origin="-1.989 0"/>
        <path style="fill: rgb(46, 139, 87); stroke-width: 4px; stroke: rgb(20, 220, 40);" d="M 250.275 200.275 L 275.275 200.275" transform="matrix(0, -1, 1, 0, -0.275, 400.275006)" bx:origin="-2.011 0"/>
        </svg>
    ]],
    targetReticle = [[
        <svg viewBox="-62.5 -62.5 125 125">
        <path d="M 62.5 0 A 62.5 62.5 0 0 1 0 62.5 A 62.5 62.5 0 0 1 -62.5 0 A 62.5 62.5 0 0 1 0 -62.5 A 62.5 62.5 0 0 1 62.5 0 Z" style="fill: none; stroke-dasharray: 65; stroke: rgb(246, 0, 254); stroke-width: 6px;"/>
        <path d="M 5 0 A 5 5 0 0 1 0 5 A 5 5 0 0 1 -5 0 A 5 5 0 0 1 0 -5 A 5 5 0 0 1 5 0 Z" style="fill: rgb(246, 0, 254); stroke: rgb(246, 0, 254);"/>
        </svg>
    ]],
    maneuverNode = [[
        <svg viewBox="-3.175 0 106.391 103.181">
        <path style="fill: rgb(216, 216, 216); stroke-width: 5px; stroke: rgb(21, 0, 255);" d="M 22.767 1.724 L 76.628 1.715" transform="matrix(-1, 0, 0, -1, 99.718166, 3.439)" bx:origin="0.5 -5363.962451"/>
        <path style="fill: rgb(216, 216, 216); stroke: rgb(21, 0, 255); stroke-width: 3px;" d="M 34.86 15.167 L 65.007 15.161" transform="matrix(0, 1, -1, 0, 65.187944, -34.859944)" bx:origin="1.658538 1.046562"/>
        <path d="M 52.5 50 C 52.5 51.381 51.38 52.5 50 52.5 C 48.619 52.5 47.5 51.381 47.5 50 C 47.5 48.619 48.619 47.5 50 47.5 C 51.38 47.5 52.5 48.619 52.5 50 Z" style="stroke: rgb(21, 0, 255); fill: rgb(21, 0, 255);" bx:origin="0 0"/>
        <path style="fill: rgb(216, 216, 216); stroke-width: 5px; stroke: rgb(21, 0, 255);" d="M 23.09 98.285 L 76.951 98.276" transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -20.694729, 50.010377)" bx:origin="0.5 -5363.962451"/>
        <path style="fill: rgb(216, 216, 216); stroke: rgb(21, 0, 255); stroke-width: 3px;" d="M 0.021 50 L 30.168 49.994" transform="matrix(-0.707107, -0.707107, 0.707107, -0.707107, 50.035558, 120.725971)" bx:origin="1.658538 1.046562"/>
        <path style="fill: rgb(216, 216, 216); stroke-width: 5px; stroke: rgb(21, 0, 255);" d="M 23.09 98.285 L 76.951 98.276" transform="matrix(0.707107, 0.707107, -0.707107, 0.707107, 49.996057, -20.729293)" bx:origin="0.5 -5363.962451"/>
        <path style="fill: rgb(216, 216, 216); stroke: rgb(21, 0, 255); stroke-width: 3px;" d="M 0.021 50 L 30.168 49.994" transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -20.704741, 50.014894)" bx:origin="1.658538 1.046562"/>
        </svg>
    ]],
    centerofMass = [[
        <svg viewBox="-74.652 -64 148.511 131.373" >
        <path style="fill: rgb(216, 216, 216); stroke-width: 5px; stroke: rgb(255, 60, 0);" d="M -42.75 -62.99 L 42.25 -63" transform="matrix(-1, 0, 0, -1, 0.01, -125.990009)" bx:origin="0.503 0.5"/>
        <path style="fill: rgb(216, 216, 216); stroke: rgb(255, 60, 0); stroke-width: 3px;" d="M -17.6 -46.39 L 17.4 -46.4" transform="matrix(0, 1, -1, 0, -46.390001, -46.400003)" bx:origin="0.503 0.5"/>
        <path style="fill: rgb(216, 216, 216); stroke-width: 5px; stroke: rgb(255, 60, 0);" d="M 9.977 30.349 L 94.977 30.339" transform="matrix(0.5, -0.866025, 0.866025, 0.5, 0.08732, 60.839247)" bx:origin="0.503 0.5"/>
        <path style="fill: rgb(216, 216, 216); stroke: rgb(255, 60, 0); stroke-width: 3px;" d="M 20.751 22.051 L 55.751 22.041" transform="matrix(-0.866025, -0.5, 0.5, -0.866025, 60.550264, 60.316404)" bx:origin="0.503 0.5"/>
        <path style="fill: rgb(216, 216, 216); stroke-width: 5px; stroke: rgb(255, 60, 0);" d="M -96.025 30.583 L -11.025 30.573" transform="matrix(0.5, 0.866025, -0.866025, 0.5, -0.153671, 61.422167)" bx:origin="0.503 0.5"/>
        <path style="fill: rgb(216, 216, 216); stroke: rgb(255, 60, 0); stroke-width: 3px;" d="M -56.499 22.283 L -21.499 22.273" transform="matrix(0.866025, -0.5, 0.5, 0.866025, -16.349816, -16.462319)" bx:origin="0.503 0.5"/>
        <path d="M 5 0 A 5 5 0 0 1 0 5 A 5 5 0 0 1 -5 0 A 5 5 0 0 1 0 -5 A 5 5 0 0 1 5 0 Z" style="stroke: rgb(255, 60, 0); fill: rgb(255, 60, 0);"/>
        </svg>
    ]]
}
