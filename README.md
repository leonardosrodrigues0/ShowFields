# ShowFields Swift Package

Apple's SpriteKit game framework allows the developer to use different kinds of physics fields through [`SKFieldNode`](https://developer.apple.com/documentation/spritekit/skfieldnode/). To visualize these fields, [`SKView`](https://developer.apple.com/documentation/spritekit/skview) has a [`showsFields`](https://developer.apple.com/documentation/spritekit/skview/1520443-showsfields) property, but unfortunately it is not customizable and doesn't always work properly.

This package was created to easily add field visualization to a Swift project, inspired in the code used in the [Field Control Game](https://apps.apple.com/us/app/field-control-game/id1628106038).

## Usage

The `ShowFieldsExample` project provides an example on how to add the package components to your SpriteKit project.

1. Add a `DrawLinesView` to your view hierarchy behind your `SKView`, as seen in `ShowFieldsExample/GameView.swift`.

2. Add a `FieldSampler` to your `SKScene`. A reference to the `DrawLinesView` must be passed in the sampler initializer so that it can tell the view what to draw.

3. Call `updateLines()` in your update loop (typically in your scene's `update(_:)` method).
