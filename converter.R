library(shiny)
library(igraph)

# Function to parse grammar and create the graph
create_automaton <- function(grammar) {
  lines <- strsplit(grammar, "\n")[[1]]
  lines <- trimws(lines)
  
  edges <- list()
  nodes <- unique(c("S"))  
  final_states <- c() 
  
  for (line in lines) {
    if (line != "") {
      parts <- strsplit(line, "->")[[1]]
      from <- trimws(parts[1])
      to <- trimws(parts[2])
      
      if (nchar(to) > 1) {
        symbols <- strsplit(to, "")[[1]]
        state <- symbols[length(symbols)]
        symbols <- paste(symbols[-length(symbols)], collapse = ", ")
      } else {
        symbols <- to
        state <- "Z"  # Change state to "Z"
        final_states <- c(final_states, from)  # Add from node to final states
      }
      
      nodes <- unique(c(nodes, from, state))
      edges <- append(edges, list(c(from, state, symbols)))
    }
  }
  
  g <- graph.empty(directed = TRUE)
  g <- add_vertices(g, length(nodes), name = nodes)
  
  for (edge in edges) {
    from <- V(g)[name == edge[1]]
    to <- V(g)[name == edge[2]]
    symbols <- edge[3]
    
    if (length(from) > 0 && length(to) > 0) {
      g <- add_edges(g, c(from, to), label = symbols)
    } else {
      stop("Error: Invalid edge from ", edge[1], " to ", edge[2])
    }
  }
  
  V(g)$color <- "lightblue"
  V(g)$color[V(g)$name == "S"] <- "green"
  V(g)$color[V(g)$name == "Z"] <- "red"  # Color the Z node red
  
  return(g)
}



# Shiny UI
ui <- fluidPage(
  titlePanel("Regular Grammar to Finite Automaton Converter"),
  sidebarLayout(
    sidebarPanel(
      textAreaInput("grammar", "Regular Grammar", rows = 10, cols = 40, value = "S -> aA\nS -> bA\nA -> aB\nA -> bB\nA -> a\nB -> aA\nB -> bA")
    ),
    mainPanel(
      plotOutput("automatonPlot")
    )
  )
)

# Shiny Server
server <- function(input, output) {
  output$automatonPlot <- renderPlot({
    req(input$grammar)
    grammar <- input$grammar
    
    g <- create_automaton(grammar)
    
    curves <- igraph::curve_multiple(g)
    
    plot(g, edge.label = E(g)$label, edge.curved = curves, vertex.size = 30, 
         vertex.label.cex = 1.2, vertex.label.dist = 0, vertex.label.color = "black", edge.arrow.size = 0.5)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
