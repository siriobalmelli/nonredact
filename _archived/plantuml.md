---
layout:		default
title:		Text-Driven Diagrams and Documentation
date:		2019-09-25
categories: articles
---

# text-driven diagrams and documentation

*or, how I learned to stop worrying and love [PlantUML](http://plantuml.com/)*

## Motivation

The need to be able to quickly set down and *show*, visually:

- sequences (process, business logic)
- network infrastructure (machines, links)
- software structure (modules, dependencies)
- physical infrastructure (cabling, ports)

... combined with the need to:

- version control this data
- manipulate it with existing tools that handle text data
- render it locally or have it rendered on the web

Whatever else, it must also *be terse* and *high-level*,
something like [GraphViz](https://graphviz.org/) is too complex
for this use case.

### Example

1. Some basic UML Code using the [C4 Model](https://c4model.com/):
    ```uml
    @startuml C4_Elements

    ' import from the included UML stdlib: https://github.com/plantuml/plantuml-stdlib
    !include <C4/C4_Container>

    ' use high-level constructs
    Person(personAlias, "Label", "Optional Description")
    Container(containerAlias, "Label", "Technology", "Optional Description")
    System(systemAlias, "Label", "Optional Description")

    Rel(personAlias, containerAlias, "Label", "Optional Technology")
    @enduml
    ```

1. Let's put that in a `.iuml` file: [assets/diagram.iuml](../assets/diagram.iuml)

1. We can render this locally from the command line:
    ```bash
    nonredact$ plantuml -pipe <assets/diagram.iuml >out.png
    ```
    This means any CI pipeline can do this, no web services required!

1. We can also ask <plantuml.com> to render our file for us,
by linking to a URL on *their* site with an argument pointing them back
to this github page:
    ```markdown
    ![rendered diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.github.com/siriobalmelli/nonredact/master/assets/diagram.iuml)
    ```
    ![rendered diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.github.com/siriobalmelli/nonredact/master/assets/diagram.iuml)
