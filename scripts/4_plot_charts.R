# 1 Direct health -------------------------------------------------------------
## R value --------------------------------------------------------------------
plots[["1r"]] <- plot_ly(
  data = datasets[["1r"]],
  x = ~ date,
  hoverinfo = "text",
  y = ~ middle
) %>%
  add_trace(
    type = "scatter",
    mode = "markers",
    marker = list(opacity = 0),
    error_y = ~list(array = high - middle,
                    arrayminus = middle - low,
                    color = col_palette["sg_blue"],
                    thickness = 5,
                    width = 6),
    text = ~ text
  ) %>%
  add_style_chart() %>%
  layout(
    title = "Note: this chart shows dummy data",
    xaxis = list(showspikes = TRUE,
                 spikemode = "across"),
    shapes = shapes[["1r"]],
    annotations = filter(annotations, plot == "1r", dataset == "1r") %>%
      pmap(list)
  )

## Number of infectious people ------------------------------------------------
plots[["1_infect"]] <- plot_ly(
  data = datasets[["1_infect"]],
  x = ~ date,
  hoverinfo = "text",
  y = ~ midpoint
) %>%
  add_ribbons(
    ymin = ~ lowbound,
    ymax = ~ upperbound,
    line = list(color = "transparent"),
    fillcolor = col_palette["sg_light_blue"]
  ) %>%
  add_trace(
    type = "scatter",
    mode = "lines+markers",
    marker = list(color = col_palette["sg_blue"]),
    line = list(color = col_palette["sg_blue"]),
    text = ~ text
  ) %>%
  add_style_chart() %>%
  layout(
    showlegend = FALSE,
    annotations = filter(annotations,
                         plot == "1_infect",
                         dataset == "1_infect"),
    shapes = shapes[["1_infect"]]
  )

## Number of cases ------------------------------------------------------------
plots[["1_cases"]] <- plot_ly(
  data = datasets[["1_cases"]],
  x = ~ date,
  y = ~ cases,
  hoverinfo = "text"
) %>%
  add_trace(
    name = "Cases",
    y = ~ cases,
    type = "bar",
    marker = list(color = col_palette["sg_grey"]),
    text = ~ cases_text
  ) %>%
  add_trace(
    name = "7 day average",
    y = ~ cases_7day_avg,
    type = "scatter",
    mode = "markers+lines",
    marker = list(size = 7, color = col_palette["sg_blue"]),
    line = list(color = col_palette["sg_blue"]),
    text = ~ cases_7day_avg_text
  ) %>%
  add_style_chart() %>%
  layout(
    showlegend = FALSE,
    shapes = list(
      list(
        type = "line",
        layer = "below",
        x0 = dates[["lockdown"]],
        x1 = dates[["lockdown"]],
        y0 = 0,
        y1 = 450,
        line = list(color = col_palette["sg_grey"], dash = "dot")
      )
    ),
    annotations = filter(annotations, plot == "1_cases", dataset == "1_cases"),
    legend = list(orientation = "h",
                  x = 0, y = 100)
  )

## Deaths ---------------------------------------------------------------------
plots[["1a"]] <- plot_ly(
  data = datasets[["1a"]],
  x = ~ Date,
  y = ~ count,
  hoverinfo = "text"
) %>%
  add_trace(
    name = "Deaths",
    y = ~ count,
    type = "bar",
    marker = list(color = col_palette["sg_grey"]),
    text = ~ count_text
  ) %>%
  add_trace(
    name = "7 day average",
    y = ~ count_7day_avg,
    type = "scatter",
    mode = "markers+lines",
    marker = list(size = 7, color = col_palette["sg_blue"]),
    line = list(color = col_palette["sg_blue"]),
    text = ~ count_7day_avg_text
  ) %>%
  add_style_chart() %>%
  layout(
    showlegend = FALSE,
    shapes = list(
      list(
        type = "line",
        layer = "below",
        x0 = dates[["lockdown"]],
        x1 = dates[["lockdown"]],
        y0 = 0,
        y1 = 160,
        line = list(color = col_palette["sg_grey"], dash = "dot")
      )
    ),
    annotations = filter(annotations, plot == "1a", dataset == "1a") %>%
      pmap(list), #convert to list
    legend = list(orientation = "h",
                  x = 0, y = 100)
  )

## Deaths by setting ----------------------------------------------------------
plots[["1b"]] <- plot_ly(
  data = datasets[["1b"]],
  x = ~ week_ending_date,
  y = ~ deaths,
  marker = list(size = 7),
  name = ~ setting,
  linetype = ~ linetype,
  hoverinfo = "text",
  text = ~ text
) %>%
  add_trace(
    type = "scatter",
    mode = "markers+lines"
  ) %>%
  config(displayModeBar = FALSE,
         showAxisDragHandles = FALSE) %>%
  layout(
    showlegend = FALSE,
    xaxis = list(
      linecolor = rgb(255, 255, 255, maxColorValue = 255),
      width = 0,
      fill = NA,
      fixedrange = TRUE,
      bty = "n",
      showline = FALSE,
      title = "",
      showgrid = FALSE,
      zeroline = FALSE
    ),
    yaxis = list(
      fixedrange = TRUE,
      showline = FALSE,
      title = "",
      showgrid = FALSE,
      tick0 = 0,
      zeroline = FALSE
    ),
    colorway = c(col_palette[c("sg_grey", "sg_blue", "sg_blue", "sg_grey")]),
    paper_bgcolor = "rgba(0, 0, 0, 0)",
    plot_bgcolor = "rgba(0, 0, 0, 0)",
    margin = list(l = 0,
                  r = 0),
    legend = list(orientation = "h",
                  x = 0, y = 100),
    annotations = filter(annotations, plot == "1b", dataset == "1b") %>%
      pmap(list) #transpose and convert to list
  ) %>%
  htmlwidgets::onRender(
    "function(el, x) {
      Plotly.d3.select('.cursor-pointer').style('cursor', 'crosshair')}"
  )

## People in hospital with COVID-19 -------------------------------------------
plots[["1c"]] <- plot_ly(
  data = datasets[["1c"]],
  x = ~ date,
  y = ~ covid_patients,
  marker = list(size = 7),
  name = ~ location_label,
  hoverinfo = ~ "text"
) %>%
  add_trace(type = "scatter",
            mode = "markers+lines",
            text = ~ text) %>%
  add_style_chart() %>%
  layout(showlegend = FALSE,
         colorway = c(col_palette),
         annotations = filter(annotations, plot == "1c", dataset == "1c") %>%
           pmap(list), #transpose and convert to list
         shapes = shapes[["1c"]])
  

# 2 Indirect health -----------------------------------------------------------
## A&E attendance -------------------------------------------------------------
plots[["2a"]] <- plot_ly(
  x = ~ lubridate::week(week_ending_date),
  y = ~ attendance,
  hoverinfo = ~ "text"
) %>%
  add_trace(data = datasets[["2a"]] %>%
              group_by(year = year(week_ending_date)) %>%
              filter(year != 2020),
            type = "scatter",
            mode = "lines",
            text = ~ text) %>%
  add_trace(data = datasets[["2a"]] %>%
              filter(year(week_ending_date) == 2020),
            type = "scatter",
            mode = "markers+lines",
            marker = list(size = 7),
            text = ~ text) %>%
  add_style_chart() %>%
  layout(
    xaxis = list(title = "Week number"),
    showlegend = FALSE,
    colorway = c(col_palette),
    shapes = shapes[["2a"]],
    annotations = filter(annotations, plot == "2a", dataset == "2a") %>%
      mutate(x = week(x)) %>% # Use week numbers instead of dates
      pmap(list) #transpose and convert to list
  )

## Emergency and planned admissions -------------------------------------------
plots[["2_admissions"]] <- plot_ly(
  data = datasets[["2_admissions"]],
  x = ~ week,
  marker = list(size = 7),
  name = ~ Admission_type,
  hoverinfo = ~ "text"
) %>%
  add_trace(
    type = "scatter",
    y = ~ Average_2018_2019,
    mode = "markers+lines",
    line = list(color = col_palette["sg_grey"]),
    marker = list(color = col_palette["sg_grey"]),
    text = ~text_2018_19
  ) %>%
  add_trace(
    type = "scatter",
    y = ~ Count,
    text = ~text_2020,
    mode = "markers+lines",
    line = list(color = col_palette["sg_blue"]),
    marker = list(color = col_palette["sg_blue"])
  ) %>%
  add_style_chart() %>%
  layout(showlegend = FALSE,
         xaxis = list(title = "Week number"),
         annotations = filter(annotations,
                              plot == "2_admissions",
                              dataset == "2_admissions") %>%
           mutate(x = week(x)) %>% # Use week numbers instead of dates
           pmap(list))

## Excess deaths --------------------------------------------------------------
plots[["2_excess"]] <- plot_ly(
  data = datasets[["2_excess"]],
  x = ~ week,
  y = ~ count,
  hoverinfo = ~ "text"
) %>%
  add_ribbons(
    data = datasets[["2_excess_spark"]],
    ymin = ~ avg_2015_19,
    ymax = ~ all_2020,
    line = list(color = "transparent"),
    fillcolor = col_palette["sg_light_blue"],
    fill = "tonext"
  ) %>%
  add_trace(
    data = datasets[["2_excess"]],
    text = ~text,
    type = "scatter",
    mode = "markers+lines",
    marker = list(size = 7),
    name = ~ measure,
    linetype = ~ linetype
  ) %>%
  config(displayModeBar = FALSE,
         showAxisDragHandles = FALSE) %>%
  layout(
    showlegend = FALSE,
    xaxis = list(
      linecolor = rgb(255, 255, 255, maxColorValue = 255),
      width = 0,
      fill = NA,
      fixedrange = TRUE,
      bty = "n",
      showline = FALSE,
      title = "Week number",
      showgrid = FALSE,
      zeroline = FALSE
    ),
    yaxis = list(
      fixedrange = TRUE,
      showline = FALSE,
      title = "",
      showgrid = FALSE,
      tick0 = 0,
      zeroline = FALSE
    ),
    shapes = shapes[["2_excess"]],
    annotations = filter(annotations,
                         plot == "2_excess",
                         dataset == "2_excess") %>%
      mutate(x = lubridate::week(x)) %>%
      pmap(list),
    colorway = c(col_palette[c("sg_blue", "sg_grey", "sg_blue")]),
    paper_bgcolor = "rgba(0, 0, 0, 0)",
    plot_bgcolor = "rgba(0, 0, 0, 0)",
    margin = list(l = 0,
                  r = 0)
  ) %>%
  htmlwidgets::onRender(
    "function(el, x) {
    Plotly.d3.select('.cursor-pointer').style('cursor', 'crosshair')}"
  )


# 3 Society -------------------------------------------------------------------
## Vulnerable children at school ----------------------------------------------
plots[["3a"]] <- plot_ly(
  data = datasets[["3a"]],
  x = ~ date,
  y = ~ children,
  marker = list(size = 7),
  hoverinfo = ~ "text"
) %>%
  add_style_chart() %>%
  add_trace(type = "scatter",
            mode = "markers+lines",
            text = ~ text) %>%
  layout(
    shapes = shapes[["3a"]],
    annotations = filter(annotations, plot == "3a", dataset == "3a")
  )

## Crisis applications --------------------------------------------------------
plots[["3_crisis_applications"]] <- plot_ly(
  x = ~ lubridate::month(month_ending_date, label = TRUE),
  y = ~ crisis_applications,
  hoverinfo = ~ "text"
) %>%
  add_trace(data = datasets[["3_crisis_applications"]] %>%
              group_by(year = year(month_ending_date)) %>%
              filter(year != 2020),
            type = "scatter",
            mode = "lines",
            text = ~ text) %>%
  add_trace(data = datasets[["3_crisis_applications"]] %>%
              filter(year(month_ending_date) == 2020),
            type = "scatter",
            mode = "markers+lines",
            marker = list(size = 7),
            text = ~ text) %>%
  add_style_chart() %>%
  layout(
    showlegend = FALSE,
    colorway = c(col_palette),
    shapes = shapes[["3_crisis_applications"]],
    annotations = filter(annotations,
                         plot == "3_crisis_applications",
                         dataset == "3_crisis_applications") %>%
      mutate(x = month(x)) %>% # Use week numbers instead of dates
      pmap(list) #transpose and convert to list
  )

## Crime ----------------------------------------------------------------------
plots[["3_crime"]] <- plot_ly(
  data = datasets[["3_crime"]] %>%
    group_by(crime_group),
  x = ~ paste(month, year),
  y = ~ recorded,
  name = ~ crime_group,
  hoverinfo = ~ "text"
) %>%
  add_trace(
    type = "scatter",
    mode = "markers+lines",
    marker = list(color = col_palette["sg_grey"],
                  size = 10),
    line = list(color = col_palette["sg_grey"]),
    text = ~ text
  ) %>%
  add_style_chart() %>%
  layout(
    showlegend = FALSE,
    annotations = filter(annotations,
                         plot == "3_crime",
                         dataset == "3_crime") %>%
      mutate(x = format.Date(x, "%B %Y"))
  )

# 4 Economy -------------------------------------------------------------------
plots[["4a"]] <- plot_ly(
  data = datasets[["4a"]],
  x = ~ date,
  marker = list(size = 7),
  hoverinfo = ~ "text"
) %>%
  add_style_chart() %>%
  add_trace(name = "Universal Credit Claims",
            type = "bar",
            y = ~ claims,
            text = ~ claims_text
            ) %>%
  add_trace(name = "7 day average",
            type = "scatter",
            mode = "markers+lines",
            y = ~ claims_7day_avg,
            text = ~ claims_7day_avg_text
            ) %>%
  layout(
    showlegend = FALSE,
    colorway = c(col_palette),
    shapes = shapes[["4a"]],
    annotations = filter(annotations, plot == "4a", dataset == "4a") %>%
      pmap(list) #transpose and convert to list
  )