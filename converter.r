library(shiny)
library(igraph)

# Function to parse grammar and create the graph
create_automaton <- function(grammar) {
  lines <- strsplit(grammar, "\n")[[1]]
  lines <- trimws(lines)
  
  edges <- list()
  nodes <- unique(c("S"))  # Include the initial state S
  final_states <- c()  # Inicializar un vector para almacenar los estados finales
  
  for (line in lines) {
    if (line != "") {
      parts <- strsplit(line, "->")[[1]]
      from <- trimws(parts[1])
      to <- trimws(parts[2])
      
      if (nchar(to) > 1) {
        symbol <- substr(to, 1, 1)
        state <- substr(to, 2, nchar(to))
        
        # Si el estado siguiente está vacío, marca el estado actual como final
        if (state == "") {
          final_states <- c(final_states, from)
        }
      } else {
        symbol <- to
        state <- ""
      }
      
      nodes <- unique(c(nodes, from, state))
      edges <- append(edges, list(c(from, state, symbol)))
    }
  }
  
  print(nodes)
  print(edges)
  
  # Ensure that nodes and edges are correctly populated
  if (length(nodes) == 0) stop("No nodes found")
  if (length(edges) == 0) stop("No edges found")
  
  g <- graph.empty(directed = TRUE)
  g <- add_vertices(g, length(nodes), name = nodes)
  
  for (edge in edges) {
    from <- V(g)[name == edge[1]]
    to <- V(g)[name == edge[2]]
    symbol <- edge[3]
    
    if (length(from) > 0 && length(to) > 0) {
      g <- add_edges(g, c(from, to), label = symbol)
    } else {
      stop("Error: Invalid edge from ", edge[1], " to ", edge[2])
    }
  }
  
  V(g)$color <- "lightblue"
  V(g)$color[V(g)$name == "S"] <- "green"
  V(g)$color[V(g)$name %in% final_states] <- "red"  # Colorea los estados finales de rojo
  
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
    
    plot(g, edge.label = E(g)$label, edge.curved = curves, vertex.size = 30, vertex.label.cex = 1.2, vertex.label.dist = 2, vertex.label.color = "black", edge.arrow.size = 0.5)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
