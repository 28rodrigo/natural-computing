globals [gRow gColumn i j]
breed [passengers passenger]
passengers-own [pSeatRow pSeatColumn reachedRow sittingTime isSitted insidePlane placed]

to setup
  clear-all        ; inicialização
  reset-ticks
  set gRow 1
  set gColumn 1

  ask patches [
    if pxcor = 0 and pycor = 1 [set plabel "A"]
    if pxcor = 0 and pycor = 2 [set plabel "B"]
    if pxcor = 0 and pycor = 3 [set plabel "C"]
    if pxcor = 0 and pycor = 5 [set plabel "D"]
    if pxcor = 0 and pycor = 6 [set plabel "E"]
    if pxcor = 0 and pycor = 7 [set plabel "F"]

    if pxcor >= 1 and pxcor <= 24 [
      if pycor = 8 [
        set plabel pxcor
        if pxcor mod 2 = 0 [set plabel-color red ]
      ]

      if pycor >= 1 and pycor <= 7 and pycor != 4 [
        if pycor = 1 [set pcolor 2]
        if pycor = 2 [set pcolor 3]
        if pycor = 3 [set pcolor 4]
        if pycor = 5 [set pcolor 4]
        if pycor = 6 [set pcolor 3]
        if pycor = 7 [set pcolor 2]
        ]
  ]]

  create-passengers 144 [    ; criar passageiros
    set shape "turtle"
    ;set shape "person"
    set placed false          ; inicialização das variáveis dos passageiros
    set insidePlane false
    set reachedRow false
    set isSitted false

      ; definir o acento marcado de cada um dos passageiros
    set pSeatRow gRow
    set pSeatColumn gColumn

      ; atribuir cores diferentes às diferentes secções
    (ifelse
      pSeatRow >= 19 [set color red]
      pSeatRow >= 13 and pSeatRow <= 18 [set color blue]
      pSeatRow >= 7 and pSeatRow <= 12 [set color yellow]
      [set color pink])

      ; incrementar variáveis globais gRow e gColumn para atribuir um assento aos passageiros
    if gColumn = 3 [set gColumn gColumn + 1]
    ifelse gColumn = 7 [set gColumn 1 set gRow gRow + 1] [set gColumn gColumn + 1]

      ; definir aleatoriamente o tempo (ticks) que cada passageiro demora a sentar, dependendo do seu lugar
    ifelse coin-flip [set sittingTime 2] [set sittingTime 3]


  ]

    ; Modo de distribuição dos passageiros pela fila de espera:
  (ifelse order = "Alternate Order"[ place-alternate ] order = "Random Order" [ place-random] order = "Ideal Order" [ place-ideal] order = "Sequential Order" [ place-ordered])


end

to place-random
    ; depois de criados, distribuir aleatoriamente os passagerios pela fila de espera
  ask passengers [
    move-to one-of patches with [ pxcor <= 0 and pxcor > -144 and pycor = 4 and not any? passengers-here ]
    set heading 90
    set placed true
  ]


end

to place-ideal
  ; distribuir os passageiros de maneira ideal de entrada
  set i 0
  set j 4
  ask turtles with [placed = false and pSeatColumn = 7][
    move-to patch-at (pSeatRow - 24)  4
  ]
  ask turtles with [placed = false and pSeatColumn = 1][
    move-to patch-at (pSeatRow - 48)  4
  ]
  ask turtles with [placed = false and pSeatColumn = 6][
    move-to patch-at ( pSeatRow - 72 ) 4
  ]
  ask turtles with [placed = false and pSeatColumn = 2][
    move-to patch-at ( pSeatRow - 96 ) 4
  ]
  ask turtles with [placed = false and pSeatColumn = 5][
    move-to patch-at ( pSeatRow - 120 ) 4
  ]
  ask turtles with [placed = false and pSeatColumn = 3][
    move-to patch-at ( pSeatRow - 144 ) 4
  ]
  ask turtles [set heading 90]

end
to place-ordered
    ; depois de criados, distribuir os passageiros aleatoriamente na fila de espera, mas por secções

  ask passengers with [pSeatRow >= 19 and placed = false] [
    move-to one-of patches with [pxcor <= 0 and pxcor > -36 and pycor = 4 and not any? passengers-here]
    set heading 90
    set placed true
    ]
  ask passengers with [pSeatRow >= 13 and placed = false] [
    move-to one-of patches with [pxcor <= -36 and pxcor > -72 and pycor = 4 and not any? passengers-here]
    set heading 90
    set placed true
    ]
  ask passengers with [pSeatRow >= 7 and placed = false] [
    move-to one-of patches with [pxcor <= -72 and pxcor > -108 and pycor = 4 and not any? passengers-here]
    set heading 90
    set placed true
    ]
  ask passengers with [placed = false] [
    move-to one-of patches with [pxcor <= -108 and pxcor > -144 and pycor = 4 and not any? passengers-here]
    set heading 90
    set placed true
    ]


end

to place-alternate
    ; depois de criados, distribuir os passageiros aleatoriamente na fila de espera, mas por secções alternadas (4,2,3,1)
  ask passengers with [pSeatRow >= 19 and placed = false] [
    move-to one-of patches with [pxcor <= 0 and pxcor > -36 and pycor = 4 and not any? passengers-here]
    set heading 90
    set placed true
    ]
  ask passengers with [pSeatRow >= 13 and placed = false] [
    move-to one-of patches with [pxcor <= -72 and pxcor > -108 and pycor = 4 and not any? passengers-here]
    set heading 90
    set placed true
    ]
  ask passengers with [pSeatRow >= 7 and placed = false] [
    move-to one-of patches with [pxcor <= -36 and pxcor > -72 and pycor = 4 and not any? passengers-here]
    set heading 90
    set placed true
    ]
  ask passengers with [placed = false] [
    move-to one-of patches with [pxcor <= -108 and pxcor > -144 and pycor = 4 and not any? passengers-here]
    set heading 90
    set placed true
    ]
end


to go
  ask passengers with [isSitted = false] [ ; se ainda não estiver sentado

    (ifelse             ; mudar direção dos passageiros, dependendo de onde estão na fila de espera
      xcor = -5 and ycor = 4 [set heading 90]
      xcor = -5 and ycor = -2 [set heading 0]
      xcor = 36 and ycor = -2 [set heading -90]
      xcor = 36 and ycor = -4 [set heading 0]
      xcor = -9 and ycor = -4 [set heading 90]
      xcor = -9 and ycor = -6 [set heading 0]
      [])

      ifelse reachedRow = false [                         ; se ainda não chegou à sua fila
        if not any? passengers-on patch-ahead 1 [           ; e não tiver ninguém à sua frente
          fd 1                                                ; andar para a frente
          if ycor = 4 [set insidePlane true]                  ; marcar como dentro do avião (quando estiver nesta coordenada)
          if xcor = pSeatRow and insidePlane = true [         ; se chegar à sua fila, marcar como chegado, e direccionar para o lugar
            ifelse pSeatColumn < 4 [set heading 180] [ set heading 0]
            set reachedRow true
            (ifelse
              pSeatColumn = 2 or pSeatColumn = 6
                [
                  if any? passengers-on patch-ahead 1 [ set sittingTime sittingTime + 2 ]
                ]
              pSeatColumn = 1 or pSeatColumn = 7
                [
                  if any? passengers-on patch-ahead 1 [ set sittingTime sittingTime + 2 ]
                  if any? passengers-on patch-ahead 2 [ set sittingTime sittingTime + 2 ]
                ]
              [])

         ]
      ]                                              ; se já estiver na sua fila, verificar o tempo que demora a sentar-se
    ] [ ifelse sittingTime > 0 [set sittingTime sittingTime - 1] [
            setxy pSeatRow pSeatColumn                    ; entrar para o lugar
            set isSitted true                             ; marcar como sentado
            set heading -90                               ; virar para a frente do avião
            set pcolor sky                                ; mudar a cor do lugar para melhor visualizar os passagerios já sentados
        ]]
 ]
  tick
end


to-report coin-flip
  report random 2 = 1
end
@#$#@#$#@
GRAPHICS-WINDOW
12
9
1832
267
-1
-1
9.96
1
10
1
1
1
0
0
1
1
-144
37
-12
12
0
0
1
ticks
30.0

BUTTON
12
485
90
518
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
12
522
90
558
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
577
477
973
724
Número de passageiros sentados
ticks
nr. passageiros sentados
0.0
450.0
0.0
144.0
true
false
"" ""
PENS
"Passageiros Sentados" 1.0 0 -14439633 true "" "plot count turtles with [isSitted = true]"

BUTTON
12
562
90
599
tick
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
225
529
434
669
Chooser para mudar o modo de distribuição dos passageiros pela fila de espera.\n- Random Order: Passageiros distribuídos aleatóriamente.\n- Ideal Order: Passageiros organizados na maneira ótima.\n- Alternated Order: Passageiros distribuídos por secções alternadas.\n- Sequential Order: Passageiros distribuídos por secções.
11
0.0
1

TEXTBOX
999
156
1162
270
Cor dos passageiros:\nVermelho - Filas 19-24.\nAzul - Filas 13-18.\nAmarelo - Filas 7-12.\nRosa - Filas 1-6.
15
0.0
1

CHOOSER
260
462
402
507
order
order
"Random Order" "Alternate Order" "Ideal Order" "Sequential Order"
2

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment_Sequential" repetitions="601" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 700</exitCondition>
    <metric>count turtles with [isSitted = true]</metric>
    <enumeratedValueSet variable="order">
      <value value="&quot;Sequential Order&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment_Random" repetitions="601" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 700</exitCondition>
    <metric>count turtles with [isSitted = true]</metric>
    <enumeratedValueSet variable="order">
      <value value="&quot;Random Order&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment_Allternate" repetitions="601" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 700</exitCondition>
    <metric>count turtles with [isSitted = true]</metric>
    <enumeratedValueSet variable="order">
      <value value="&quot;Alternate Order&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Ideal" repetitions="601" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 700</exitCondition>
    <metric>count turtles with [isSitted = true]</metric>
    <enumeratedValueSet variable="order">
      <value value="&quot;Ideal Order&quot;"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
