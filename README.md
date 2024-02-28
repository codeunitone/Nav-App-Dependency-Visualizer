# NAV App Dependency Visualizer

## Introduction

As the number of applications in your NAV/BC repository grows, it is increasingly difficult to keep track of the dependencies between these applications. In order to have a clean architecture, it is important to understand the relationship between these apps.
This little script reads all `app.json` files within a folder (including subfolders) and creates a markdown file that visualizes the dependencies using [mermaid](https://mermaid.js.org).

## Usage

```PowerShell
New-DependencyVisalization.ps1 -Path "<path\to\app.json>"
```

You can run following script to show the help information of the script.

```PowerShell
Get-Help .\New-DependencyVisalization.ps1
```

## Rendering the Mermaid Graph

There are [many tools](https://mermaid.js.org/intro/getting-started.html#ways-to-use-mermaid) out there to render a mermaid graph.
But you can just use the content of the output file at https://mermaid.live/

## Further information

* [Mermaid Documentation](https://mermaid.js.org/intro/)
* [Rendering a mermaid graph online](https://mermaid.live/)