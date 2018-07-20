# codebuild-pandoc

Minimalist Alpine Docker image for leveraging Pandoc in AWS CodeBuild.

## Purpose

This minimal Docker image of Pandoc is designed for use in AWS CodeBuile/CodePipeline as a means of automatically converting documents from one format to another for automated publication processes.

I designed this culling ideas from AWS and other public Dockerfiles to suit my needs for automatically publishing some of my websites from a repo of Markdown files to full HTML deployed to hosting.

## Build

Make certain that your Docker environment has at least 4GB of memory allocated.  The build process appears to require 3.5GB of memory as it progresses.
