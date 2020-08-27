breed [humans human]
breed [dead dead_singular]

humans-own [
  infected?
  contagious?
  infected_previously?
  wearmask?
  intercity_travel?
  essential_worker?
  infection-duration
  symptom_delay_duration
  serious_symptoms_day
  feel_symptoms?
  light_symptoms?
  severe_symptoms?
  age_cat
  fatality_rate
  current_infection_hours
  afford_healthcare?
  currently_treated?
  hospitalisation_rate
  home_patch
]

patches-own [
  city ; city code of patch
]


globals [
  age_cat_0-9
  age_cat_10-19
  age_cat_20-29
  age_cat_30-39
  age_cat_40-49
  age_cat_50-59
  age_cat_60-69
  age_cat_70-79
  age_cat_80+
  cumulative_infected
  cumulative_death
  total_population
  mask_penetration_rate
  recorded_transmitters
  current_hospital_beds_used
  sort-codes
  city-colors
]


to setup-agents [#total-humans #age_cat]
  create-humans #total-humans [
    set infected? false
    set contagious? false
    set essential_worker? false
    set infected_previously? false
    set wearmask? false
    set feel_symptoms? false
    set light_symptoms? false
    set severe_symptoms? false
    set intercity_travel? false
    set afford_healthcare? false
    set currently_treated? false
    setxy random-xcor random-ycor
    set home_patch patch-here
    set age_cat #age_cat


    ifelse age_cat <= age_cat_0-9 [
      set fatality_rate fatality_rate_0-9
      set hospitalisation_rate critically_ill_0-9
      set color green
    ]
    [
      ifelse age_cat <= age_cat_10-19 [
        set fatality_rate fatality_rate_10-19
        set hospitalisation_rate critically_ill_10-19
        set color green + 0.35
      ]
      [
        ifelse age_cat <= age_cat_20-29 [
          set fatality_rate fatality_rate_20-29
          set hospitalisation_rate critically_ill_20-29
          set color green + (0.35 * 2)
        ]
        [
          ifelse age_cat <= age_cat_30-39 [
            set fatality_rate fatality_rate_30-39
            set hospitalisation_rate critically_ill_30-39
            set color green + (0.35 * 3)
          ]
          [
            ifelse age_cat <= age_cat_40-49 [
              set fatality_rate fatality_rate_40-49
              set hospitalisation_rate critically_ill_40-49
              set color green + (0.35 * 4)
            ]
            [
              ifelse age_cat <= age_cat_50-59 [
                set fatality_rate fatality_rate_50-59
                set hospitalisation_rate critically_ill_50-59
                set color green + (0.35 * 5)
              ]
              [
                ifelse age_cat <= age_cat_60-69 [
                  set fatality_rate fatality_rate_60-69
                  set hospitalisation_rate critically_ill_60-69
                  set color green + (0.35 * 6)
                ]
                [
                  ifelse age_cat <= age_cat_70-79 [
                    set fatality_rate fatality_rate_70-79
                    set hospitalisation_rate critically_ill_70-79
                    set color green + (0.35 * 7)
                  ]
                  [
                      set fatality_rate fatality_rate_80+
                      set hospitalisation_rate critically_ill_80+
                      set color green + (0.35 * 8)
                  ]
                ]
              ]
            ]
          ]
        ]

      ]
    ]
  ]

  ask humans [
    set shape "face happy"
    set size 1
  ]

end



to setup-globals
  set age_cat_0-9 5
  set age_cat_10-19 15
  set age_cat_20-29 25
  set age_cat_30-39 35
  set age_cat_40-49 45
  set age_cat_50-59 55
  set age_cat_60-69 65
  set age_cat_70-79 75
  set age_cat_80+ 85
  set cumulative_infected 0
  set cumulative_death 0
  set mask_penetration_rate (mask_penetration_particles / 100)
  set current_hospital_beds_used 0
  set sort-codes n-values cities [i -> i]
  set recorded_transmitters[]
  set city-colors [8 7 6 5 18 17 16 15 28 27 26
    25 38 37 36 35]
  ;set colors-list [ 08 pink violet green brown turquoise gray sky lime violet blue
  ;  brown gray sky pink turquoise ]
end

to setup-city
  ;set-patch-size 8.5
  let step world-width / sqrt cities
  ask patches [
    let units int ((pxcor + max-pxcor) / step)
    let tens int ((pycor + max-pycor) / step)
    set city 10 * tens + units
  ]

  let aux-codes sort remove-duplicates [city] of patches
  (foreach aux-codes sort-codes [ [old new] -> ask patches with [city = old] [set city new ] ])
  ask patches [ set pcolor (item city city-colors) + 1 ]
end


to setup
  clear-all
  setup-globals
  setup-city
  setup-agents pop_0-9 age_cat_0-9
  setup-agents pop_10-19 age_cat_10-19
  setup-agents pop_20-29 age_cat_20-29
  setup-agents pop_30-39 age_cat_30-39
  setup-agents pop_40-49 age_cat_40-49
  setup-agents pop_50-59 age_cat_50-59
  setup-agents pop_60-69 age_cat_60-69
  setup-agents pop_70-79 age_cat_70-79
  setup-agents pop_80+ age_cat_80+
  setup-weather_effect
  set total_population (count humans + count dead)
  ;ask patches [set pcolor 9]
  let initial_infected_humans round (count humans * (initial_infected_proportion / 100)) ;true number of initial infected humans
  infect_people initial_infected_humans ;start off by having some infected people

  let initial_wear_mask round (count humans * (use_mask_pop / 100))
  wear_mask initial_wear_mask

  let initial_intercity_traveller round (count humans * (Intercity_traveller / 100))
  inter_city_travel initial_intercity_traveller

  let initial_essential_worker round (count humans * (Essential_workers / 100))
  essential_worker initial_essential_worker

  let initial_afford_healthcare round (count humans * (Afford_healthcare / 100))
  Affordable_healthcare initial_afford_healthcare

  reset-ticks
end

to setup-weather_effect
  if Weather_conditions = "Cold + Humid" [
    set infectivity infectivity
    ;ask patches [set pcolor 9]
  ]

  if Weather_conditions = "Cold + Dry" [
    set infectivity (0.97 * infectivity)
    ;ask patches [set pcolor 19]
  ]

  if Weather_conditions = "Hot + Dry" [
    set infectivity (0.95 * infectivity)
    ;ask patches [set pcolor 29]
  ]

  if Weather_conditions = "Hot + Humid" [
    set infectivity (0.9 * infectivity)
    ;ask patches [set pcolor 99]
  ]
end


to infect_people [#initial_infected_humans]
  ask n-of #initial_infected_humans humans with [not infected_previously?] [get-infected]
end

to wear_mask [#initial_wear_mask]
  ask n-of #initial_wear_mask humans [set wearmask? true]
  ask humans with [wearmask?] [set shape "circle"]
end

to inter_city_travel [#initial_intercity_traveller]
  ask n-of #initial_intercity_traveller humans [set intercity_travel? true]
end

to affordable_healthcare [#initial_afford_healthcare]
  ask n-of #initial_afford_healthcare humans [set afford_healthcare? true]
end

to essential_worker [#initial_essential_worker]
  ask n-of #initial_essential_worker humans [set essential_worker? true]
end


to go
  ask humans [move-forward-randomly]
  ask humans [infect]
  ask humans [infection_aftermath]
  if cumulative_infected = ((count humans with [not infected? and infected_previously?]) + cumulative_death) [
    stop
  ]
    tick
end



to move-forward-randomly ;now we have: essential_worker, intercity_travel,
  ifelse (not feel_symptoms?) [ ;people only move if no symptoms
    ifelse Total_lockdown? [ ;if no symptoms and total lockdown, don't move, except for the ones disobeying and essential workers

      if intercity_travel? [
      ifelse coin-flip? [right random 45] [left random 45]
      if confine_cities? [
        if city != [city] of home_patch [face home_patch]   ;lockdown disobeyers move randomly within city
      ]
      forward random-float 0.25
      ]

      if essential_worker? [
        ifelse coin-flip? [right random 45] [left random 45]
        forward random-float 0.2 ;essential workers move quickly between cities
      ]

    ]
    [ ;if there is no lockdown...
      if intercity_travel? [ ;intercity travellers move quicker, but does not leave the vicinity of the city
        ifelse coin-flip? [right random 45] [left random 45]
        if confine_cities? [
          if city != [city] of home_patch [face home_patch]
        ]
        forward random-float 0.25
      ]

      ifelse essential_worker? [
        ifelse coin-flip? [right random 45] [left random 45]
        forward random-float 0.2] ;essential workers continue to move quickly between cities
      [;however, the non essential workers, under no lockdown... (lockdown disobeyers do not matter)
        ifelse coin-flip? [right random 180] [left random 180]
        if confine_cities? [
          if city != [city] of home_patch [face home_patch]
        ]
        forward random-float 0.25
      ] ;if no symptoms and no lockdown, everyone moves
    ]
  ]
  [ ;if they feel symptoms, stop moving, i.e. no command.
  ]
end


to infect
  if (not infected_previously?) [ ;only applies to people not infected
    let people_around humans-on neighbors ;let "people_around" be the neighbors
    ifelse (not wearmask?) ;referring to the person ITSELF
    [let infectious_around people_around with [(infected? = true and contagious? = true)] ;people are infectious if they are infected + contagious
     let infectious_around_mask infectious_around with [wearmask?]
     let infectious_around_nomask infectious_around with [not wearmask?]
     let number_of_infectious_around count infectious_around
     let number_of_infectious_around_nomask count infectious_around_nomask
     let number_of_infectious_around_mask count infectious_around_mask

     if number_of_infectious_around > 0 [ ;if there are infected no-mask people around
       let within_infectious_distance (random(metres_per_patch) + 1) ;define infectious distance
       set within_infectious_distance within_infectious_distance + random-float ( social_distancing_metres )
       ifelse (not wearmask?) [ ;referring to neighbours without masks
         if (infectivity >= (random(100) + 1)) and within_infectious_distance <= maximum_infectious_distance [
;           let transmitter_person nobody
;           ask one-of infected_around [set transmitter_person who]
;           set recorded_transmitters lput transmitter_person recorded_transmitters
;             if length (recorded_transmitters) > 1000 [
;               set recorded_transmitters but-first recorded_transmitters
;             ]

           get-infected
         ]
       ]
       [
         if (mask_penetration_rate * infectivity >= (random(100) + 1)) and within_infectious_distance <= maximum_infectious_distance [  ;infected according to infectivity + within distance

;           let transmitter_person nobody
;           ask one-of infected_around [set transmitter_person who]
;           set recorded_transmitters lput transmitter_person recorded_transmitters
;             if length (recorded_transmitters) > 1000 [
;               set recorded_transmitters but-first recorded_transmitters
;             ]

           get-infected
         ]
       ]
      ]
    ]

    [let infectious_around people_around with [(infected? = true and contagious? = true)]
     let infectious_around_mask infectious_around with [wearmask?]
     let infectious_around_nomask infectious_around with [not wearmask?]
     let number_of_infectious_around count infectious_around
     let number_of_infectious_around_nomask count infectious_around_nomask
     let number_of_infectious_around_mask count infectious_around_mask
     if number_of_infectious_around > 0 [ ;if there are infected people around
       let within_infectious_distance (random(metres_per_patch) + 1) ;define infectious distance
       set within_infectious_distance within_infectious_distance + random-float ( social_distancing_metres )
       ifelse (not wearmask?) [
          if ((mask_penetration_rate) * infectivity >= (random(100) + 1)) and within_infectious_distance <= maximum_infectious_distance [   ;same principle as above but we multiply by penetration rate because victim is already wearing mask

;            let transmitter_person nobody
;            ask one-of infected_around [set transmitter_person who] ;transmitter person is the agent who infected the current uninfected agent
;            set recorded_transmitters lput transmitter_person recorded_transmitters
;              if length (recorded_transmitters) > 1000 [
;              set recorded_transmitters but-first recorded_transmitters ;i.e. list [104, 104, 4] means 'agent 104' infected 2 people, 'agent 4' infected 1 people
;              ]

            get-infected
          ]
       ]
       [
          if ((mask_penetration_rate) * (mask_penetration_rate) * infectivity >= (random(100) + 1)) and within_infectious_distance <= maximum_infectious_distance [   ;infected according to infectivity + within distance

;            let transmitter_person nobody
;            ask one-of infected_around [set transmitter_person who]
;            set recorded_transmitters lput transmitter_person recorded_transmitters
;              if length (recorded_transmitters) > 1000 [
;                set recorded_transmitters but-first recorded_transmitters
;              ]

            get-infected
          ] ;we multiply by mask penetration rate twice because victim and infector is wearing mask; therefore two layers of masks
       ]
     ]
    ]
  ]
end


to get-infected
  set infected_previously? true
  set infected? true
  set contagious? true
  set color yellow
  set infection-duration 24 * (random-normal infection_duration_avg 4.0) ;avg hours of infection
  set serious_symptoms_day round (infection-duration) - 1 ;serious symptom may show after 1st week
  set symptom_delay_duration 24 * (random-normal days_before_symptom_showing 3.5) ;duration (converted to ticks or hours) before symptoms show
  set current_infection_hours 0
  set cumulative_infected cumulative_infected + 1
end

to hospital_treatment
  let total_hospital_beds hospital_beds
  if current_hospital_beds_used <= total_hospital_beds - 1 [
    set currently_treated? true
    if currently_treated? [
      ;set size 4
      set contagious? false
      ;set infection-duration (0.8 * infection-duration) ;0.8x duration time
      set fatality_rate (0.25 * fatality_rate) ;0.25x fatality rate whilst treated
      set current_hospital_beds_used current_hospital_beds_used + 1
    ]
  ]
end


to recover
  set infected? false
  set feel_symptoms? false
  set light_symptoms? false
  set severe_symptoms? false
  set contagious? false
  set infection-duration 0
  set serious_symptoms_day 0
  set current_infection_hours 0
  if currently_treated? [
    set currently_treated? false
    set current_hospital_beds_used current_hospital_beds_used - 1
  ]
  set color turquoise
  set shape "face happy"
  set size 1

end


to infection_aftermath
  if infected? [
    if (current_infection_hours >= symptom_delay_duration) [
      set feel_symptoms? true

      if feel_symptoms? [
        ifelse severe_symptoms? [
          set color 13
          set shape "face sad"
        ]
        [
          set color orange
          set shape "face sad"
        ]
      ]

      if feel_symptoms? and (not severe_symptoms?) and (not light_symptoms?) [
        ifelse (hospitalisation_rate >= (random(100) + 1)) [
          set severe_symptoms? true
        ]
        [
          set light_symptoms? true ;people with light symptoms will not die. they will remain orange-faced
        ]
      ]
      ;possibly_get_critically_ill
      if afford_healthcare? and severe_symptoms? and (not currently_treated?) [ ;only severely ill who can afford healthcare is hospitalised
        hospital_treatment
      ]
    ]
    if isolate_symptomatic_individuals? [
      if feel_symptoms? [
        set contagious? false
        set shape "house"
      ]
    ]

    if currently_treated? [
      set size 2.5
      set shape "ambulance"
    ]


    ifelse (current_infection_hours >= infection-duration)
    [
     set current_infection_hours 0
     recover
    ]
    [
      set current_infection_hours current_infection_hours + 1
    ]

    if severe_symptoms? [
      if (current_infection_hours = serious_symptoms_day) [ ;later on, maybe change serious symptoms day to (infection-duration - 1)
        if (fatality_rate >= (random (100) + 1)) [
          ;update-death-statistics age-group
          if currently_treated? [
            set currently_treated? false
            set current_hospital_beds_used current_hospital_beds_used - 1
          ]
          set cumulative_death cumulative_death + 1
          set breed dead
          set shape "x"
          set size 1
          set color red
        ]
      ]
    ]
  ]
end


to-report coin-flip?
  report random 2 = 0 ;reports outcome of 0 or 1, if 0 then its true
end
@#$#@#$#@
GRAPHICS-WINDOW
556
63
1078
586
-1
-1
8.5
1
10
1
1
1
0
1
1
1
-30
30
-30
30
0
0
1
Hours elapsed
30.0

BUTTON
3
10
139
43
Setup Environment
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
138
10
274
43
Begin Simulation
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

SLIDER
1102
31
1331
64
infectivity
infectivity
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
1103
190
1275
223
metres_per_patch
metres_per_patch
0
40
40.0
1
1
NIL
HORIZONTAL

SLIDER
1102
103
1334
136
maximum_infectious_distance
maximum_infectious_distance
0
5
2.0
0.5
1
metres
HORIZONTAL

SLIDER
1339
123
1533
156
social_distancing_metres
social_distancing_metres
0
4
1.5
0.5
1
NIL
HORIZONTAL

PLOT
6
513
446
651
SIRD model
Time (hours)
Cases
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Susceptible" 1.0 0 -10899396 true "" "plot count humans with [not infected? and not infected_previously?]"
"Infected" 1.0 0 -1184463 true "" "plot (count humans with [color = yellow] + count humans with [color = orange])"
"Recovered" 1.0 0 -14835848 true "" "plot count humans with [color = turquoise]"
"Dead" 1.0 0 -2674135 true "" "plot cumulative_death"

SLIDER
374
132
546
165
fatality_rate_0-9
fatality_rate_0-9
0
100
3.0
1
1
%
HORIZONTAL

SLIDER
374
177
548
210
fatality_rate_10-19
fatality_rate_10-19
0
100
7.0
1
1
%
HORIZONTAL

SLIDER
374
223
548
256
fatality_rate_20-29
fatality_rate_20-29
0
100
15.0
1
1
%
HORIZONTAL

SLIDER
372
262
546
295
fatality_rate_30-39
fatality_rate_30-39
0
100
23.0
1
1
%
HORIZONTAL

SLIDER
372
302
546
335
fatality_rate_40-49
fatality_rate_40-49
0
100
36.0
1
1
%
HORIZONTAL

SLIDER
372
344
546
377
fatality_rate_50-59
fatality_rate_50-59
0
100
46.0
1
1
%
HORIZONTAL

SLIDER
372
385
546
418
fatality_rate_60-69
fatality_rate_60-69
0
100
58.0
1
1
%
HORIZONTAL

SLIDER
372
427
546
460
fatality_rate_70-79
fatality_rate_70-79
0
100
67.0
1
1
%
HORIZONTAL

SLIDER
374
469
546
502
fatality_rate_80+
fatality_rate_80+
0
100
80.0
1
1
%
HORIZONTAL

SLIDER
4
135
176
168
pop_0-9
pop_0-9
0
200
30.0
1
1
people
HORIZONTAL

SLIDER
4
179
176
212
pop_10-19
pop_10-19
0
200
57.0
1
1
people
HORIZONTAL

SLIDER
5
225
177
258
pop_20-29
pop_20-29
0
200
81.0
1
1
people
HORIZONTAL

SLIDER
7
264
179
297
pop_30-39
pop_30-39
0
200
111.0
1
1
people
HORIZONTAL

SLIDER
4
305
176
338
pop_40-49
pop_40-49
0
200
145.0
1
1
people
HORIZONTAL

SLIDER
4
348
176
381
pop_50-59
pop_50-59
0
200
96.0
1
1
people
HORIZONTAL

SLIDER
4
389
176
422
pop_60-69
pop_60-69
0
200
64.0
1
1
people
HORIZONTAL

SLIDER
4
430
176
463
pop_70-79
pop_70-79
0
200
53.0
1
1
people
HORIZONTAL

SLIDER
4
473
176
506
pop_80+
pop_80+
0
200
23.0
1
1
people
HORIZONTAL

SLIDER
1102
66
1332
99
infection_duration_avg
infection_duration_avg
0
50
21.0
1
1
days
HORIZONTAL

SLIDER
1102
135
1334
168
days_before_symptom_showing
days_before_symptom_showing
0
infection_duration_avg
5.0
1
1
NIL
HORIZONTAL

MONITOR
558
15
648
61
Total infected
cumulative_infected
17
1
11

MONITOR
658
15
741
61
Total deaths
cumulative_death
17
1
11

SLIDER
5
50
208
83
initial_infected_proportion
initial_infected_proportion
0
10
1.0
1
1
%
HORIZONTAL

MONITOR
749
16
845
61
Total recoveries
count humans with [not infected? and infected_previously?]
17
1
11

MONITOR
996
592
1083
637
Days Elapsed
precision (ticks / 24) 1
17
1
11

SLIDER
1342
35
1535
68
use_mask_pop
use_mask_pop
0
100
0.0
1
1
%
HORIZONTAL

BUTTON
278
10
353
43
go once
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

SLIDER
1342
68
1535
101
mask_penetration_particles
mask_penetration_particles
0
100
56.0
1
1
%
HORIZONTAL

TEXTBOX
1343
18
1493
36
Impact of masks
13
0.0
1

TEXTBOX
1103
15
1253
33
Virus parameters
13
0.0
1

TEXTBOX
1103
175
1253
193
Environment scaling
13
0.0
1

MONITOR
849
16
974
62
Current susceptibles
count humans with [not infected? and not infected_previously?]
17
1
11

TEXTBOX
1343
106
1507
125
Effect of social distancing
13
0.0
1

SWITCH
1342
219
1489
252
Total_lockdown?
Total_lockdown?
1
1
-1000

TEXTBOX
1343
158
1493
176
Effect of lockdown
13
0.0
1

SLIDER
1343
288
1515
321
Intercity_traveller
Intercity_traveller
0
100
50.0
1
1
%
HORIZONTAL

TEXTBOX
1343
255
1528
287
Intercity travellers move quickly, but does not leave the city
10
0.0
1

MONITOR
979
16
1079
62
Total population
total_population
17
1
11

SWITCH
1103
285
1328
318
Isolate_symptomatic_individuals?
Isolate_symptomatic_individuals?
0
1
-1000

TEXTBOX
1103
253
1315
282
Symptomatic individuals become quarantined and non-contagious
10
0.0
1

TEXTBOX
1343
178
1528
221
During lockdown, individuals are not allowed to move, except for essential workers and intercity travellers
10
0.0
1

TEXTBOX
1103
233
1253
251
Effect of treatment
13
0.0
1

SLIDER
1540
148
1712
181
Afford_healthcare
Afford_healthcare
0
100
100.0
1
1
%
HORIZONTAL

SLIDER
1539
79
1711
112
hospital_beds
hospital_beds
0
150
5.0
1
1
beds
HORIZONTAL

MONITOR
906
592
998
638
Beds occupied
current_hospital_beds_used
17
1
11

TEXTBOX
1540
26
1707
46
Hospital capacity
13
0.0
1

TEXTBOX
1540
48
1718
76
People under treatment will have fatality rate reduced by 75%
11
0.0
1

SLIDER
184
130
357
163
critically_ill_0-9
critically_ill_0-9
0
100
0.1
1
1
%
HORIZONTAL

SLIDER
183
178
356
211
critically_ill_10-19
critically_ill_10-19
0
100
0.3
1
1
%
HORIZONTAL

SLIDER
184
222
357
255
critically_ill_20-29
critically_ill_20-29
0
100
1.2
1
1
%
HORIZONTAL

SLIDER
184
262
357
295
critically_ill_30-39
critically_ill_30-39
0
100
3.2
1
1
%
HORIZONTAL

SLIDER
184
302
357
335
critically_ill_40-49
critically_ill_40-49
0
100
4.9
1
1
%
HORIZONTAL

SLIDER
184
344
357
377
critically_ill_50-59
critically_ill_50-59
0
100
10.2
1
1
%
HORIZONTAL

SLIDER
184
385
357
418
critically_ill_60-69
critically_ill_60-69
0
100
16.6
1
1
%
HORIZONTAL

SLIDER
184
427
357
460
critically_ill_70-79
critically_ill_70-79
0
100
24.3
1
1
%
HORIZONTAL

SLIDER
185
470
358
503
critically_ill_80+
critically_ill_80+
0
100
27.3
1
1
%
HORIZONTAL

TEXTBOX
182
98
371
127
Severe symptomatic cases (Possibly fatal and requires medical attention)
11
0.0
1

TEXTBOX
5
115
218
134
Population size
11
0.0
1

TEXTBOX
378
100
546
128
Fatality rate of severe symptomatic cases
11
0.0
1

TEXTBOX
1540
116
1707
145
Percentage of population that can afford healthcare
11
0.0
1

TEXTBOX
382
10
535
73
PANDEMIC SIMULATION
25
0.0
1

CHOOSER
1539
252
1708
297
Weather_conditions
Weather_conditions
"Cold + Humid" "Cold + Dry" "Hot + Dry" "Hot + Humid"
0

TEXTBOX
1539
196
1754
222
Impact of weather
13
0.0
1

TEXTBOX
1539
216
1718
245
Infectivity is reduced under hotter and humid conditions
11
0.0
1

PLOT
1096
330
1711
529
Infectivity
Time (hours)
% of population
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total infected" 1.0 0 -11221820 true "" "plot 100 * count humans with [infected?] / total_population"
"Asymptomatic" 1.0 0 -1184463 true "" "plot 100 * count humans with [infected? and not feel_symptoms?] / total_population"
"Symptomatic" 1.0 0 -16777216 true "" "plot 100 * count humans with [infected? and feel_symptoms?] / total_population"
"Light symptoms" 1.0 0 -955883 true "" "plot 100 * count humans with [light_symptoms?] / total_population"
"Severe symptoms" 1.0 0 -5298144 true "" "plot 100 * count humans with [severe_symptoms?] / total_population"
"Dead" 1.0 0 -2064490 true "" "plot 100 * cumulative_death / total_population"

MONITOR
798
592
907
638
% Asymptomatic
precision (100 * count humans with [infected? and not feel_symptoms?] / (count humans with [infected?])) 0
17
1
11

MONITOR
666
592
796
638
% Currently infected
precision (100 * count humans with [infected?] / (count humans)) 0
17
1
11

MONITOR
592
592
667
638
CFR (%)
100 * (cumulative_death / cumulative_infected)
2
1
11

MONITOR
455
592
591
638
Cumulative % infected
100 * (cumulative_infected / total_population)
1
1
11

CHOOSER
1266
548
1405
594
Cities
Cities
1 4 9 16
3

SWITCH
1420
549
1552
584
confine_cities?
confine_cities?
0
1
-1000

SLIDER
1266
605
1439
640
Essential_workers
Essential_workers
0
20
5.0
1
1
%
HORIZONTAL

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

ambulance
false
0
Rectangle -7500403 true true 30 90 210 195
Polygon -7500403 true true 296 190 296 150 259 134 244 104 210 105 210 190
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Circle -16777216 true false 69 174 42
Rectangle -1 true false 288 158 297 173
Rectangle -1184463 true false 289 180 298 172
Rectangle -2674135 true false 29 151 298 158
Line -16777216 false 210 90 210 195
Rectangle -16777216 true false 83 116 128 133
Rectangle -16777216 true false 153 111 176 134
Line -7500403 true 165 105 165 135
Rectangle -7500403 true true 14 186 33 195
Line -13345367 false 45 135 75 120
Line -13345367 false 75 135 45 120
Line -13345367 false 60 112 60 142

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
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
