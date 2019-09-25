---
layout:		default
title:		Text-driven Diagrams
date:		2019-09-25
categories: articles
---

# Text-driven Diagrams

*or, how I learned to stop worrying and love [PlantUML]*

## Motivation

The need to be able to quickly set down and *show*, visually:

- sequences (process, business logic)
- network infrastructure (machines, links)
- software structure (modules, dependencies)
- physical infrastructure (cabling, ports)

It must be:

1. Text-based:
    - can be version-controlled alongside code
    - can be manipulated with existing text tools (`vim`, `sed`, `grep`, etc)

    This excludes visual-only tools such as:
    - [draw.io](https://www.draw.io/)
    - [visio](https://products.office.com/en-ww/visio)
    - [lucidchart](https://www.lucidchart.com)

1. *Terse* and *high-level*:
    - very quick to use
    - approachable by non-coders (managers, sysadmins, designers)

    This excludes powerful but complex tools like:
    - [GraphViz](https://graphviz.org/).

1. Able to be rendered locally, without sending data elsewhere:
    - can be included in a CI pipeline
    - can be used without violating privacy

    This excludes cloud rendering platforms such as:
    - [yuml.me](https://yuml.me/)
    - [structurizr](https://structurizr.com/)

    This also excludes rendering platforms which do not have a CLI
    interface, such as:
    - [drawthe.net](https://github.com/cidrblock/drawthe.net)

## The solution: [PlantUML]

1. The Unified Modling Language ([UML] for short) itself is very powerful,
and has quite a bit of pedigree:
<https://en.m.wikipedia.org/wiki/Unified_Modeling_Language>

2. [PlantUML] has a very comprehensive array of tooling available:
<http://plantuml.com/running>

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

1. We can also ask <http://plantuml.com> to render our file for us,
by linking to a URL on *their* site with an argument pointing them back
to our `.iuml` file in this git repo:

    This is the markdown code:
    ```markdown
    ![rendered diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.github.com/siriobalmelli/nonredact/master/assets/diagram.iuml)
    ```

    And this is the rendered diagram:
    ![rendered diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.github.com/siriobalmelli/nonredact/master/assets/diagram.iuml)

[UML]: http://uml.org/
[PlantUML]: http://plantuml.com/
