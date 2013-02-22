Before following these getting start, please make sure you correctly [install](https://github.com/hubiquitus/hubiquitus/tree/master/docs/Readme.md) hubiquitus

## Run an example

You're now ready to use Hubiquitus.
We provide a topology's sample you can use to execute a Hubiquitus.
To launch it, use this command in you `hubiquitus` folder
```
$ coffee lib/launcher.coffee
```

Hubiquitus is now running. You can use any of our hAPI to send or receive hMessage

# Building your own hubiquitus projet

## Building your own actor

Hubiquitus provide some specific actor to build your project. But if our actors are not enough for your needs, you can build and use your own actor

> You can find details about our hubiquitus actor [here](https://github.com/hubiquitus/hubiquitus/tree/master/docs/actors)

Every Hubiquitus's actor is write in Coffee-Script.

To build your actor, you just need to extend Actor class of Hubiquitus and override needed function :

```coffee-script
{Actor} = require "hubiquitus"

class myActor extends Actor

  constructor: (topology) ->
    super #This instruction is mandatory to correctly start your actor
    @type = 'myActor'

  onMessage: (hMessage) ->
    console.log "myActor receive a hMessage", hMessage

exports.myActor = myActor
exports.newActor = (topology) ->
  new myActor(topology)
```

> You can override some over functions depending your needs, for more details about these functions see [hActor](https://github.com/hubiquitus/hubiquitus/tree/master/docs/actors/hActor)

## Building your own adapter

Hubiquitus provide some specific adapter to allow communication between actors or with external API (like Twitter). But if our adapters are not enough for your needs, you can build an use you own adapters.

> You can find details about our Hubiquitus adapter [here](https://github.com/hubiquitus/hubiquitus/tree/master/docs/adapters)

Every Hubiquitus's adapter's is write in Coffee-Script.

You can build inbound adapter or outbound adapter

> If you adapter is both IN and OUT, build an outbound adapter

To build your inbound adapter, you just need to extend InboundAdapter class of Hubiquitus and override needed function :

```coffee-script
{InboundAdapter} = require("hubiquitus").adapter

class myInboundAdapter extends InboundAdapter

  constructor: (properties) ->
    super
    # Add your initializing instructions

  start: ->
    unless @started
      # Add your starting instructions
      @owner.emit "message", hMessage # To send the hMessage to the actor
      super

  stop: ->
    if @started
      # Add your stopping instructions
      super

exports.myInboundAdapter = myInboundAdapter
exports.newAdapter = (properties) ->
  new myInboundAdapter(properties)
```

To build your inbound adapter, you just need to extend OutboundAdapter class of Hubiquitus and override needed function :

```coffee-script
{OutboundAdapter} = require("hubiquitus").adapter

class myInboundAdapter extends OutboundAdapter

  constructor: (properties) ->
    super
    # Add your initializing instructions

  start: ->
    unless @started
      # Add your starting instructions
      super

  stop: ->
    if @started
      # Add your stopping instructions
      super

  send: (message) ->
    # Add your sending instruction

exports.myOutboundAdapter = myOutboundAdapter
exports.newAdapter = (properties) ->
  new myOutboundAdapter(properties)
```
> You can override some over functions depending your needs, for more details about these functions see [Adapters](https://github.com/hubiquitus/hubiquitus/tree/master/docs/adapters/hAdapters)

## Building your project's topology

When all your actors and adapters are build and you have think about your project architecture, you are ready to build your topology.

You can find a topology sample [here](https://github.com/hubiquitus/hubiquitus/tree/master/samples/myProject/myTopology.json) and detail about actor's topology [here](https://github.com/hubiquitus/hubiquitus/tree/master/docs/actors)

## Running your project

We will run a sample project which you can find in [myProject](https://github.com/hubiquitus/hubiquitus/tree/master/samples/myProject)

Before running your project you need to add the require reference. To do it, use there commands line in your project folder :

```
$ npm install git://github.com/hubiquitus/hubiquitus.git
$ npm install adapters/myAdapter adapters/myAdapter2 actors/myActor actors/myActor2
```
> In the second command line, you need to install all your actors and adapters. In this example, we install all myProject's actors and adapters

You are now ready to run your project. To do it, use there commands line in your project folder :

```
$ cd node_modules/hubiquitus
$ coffee lib/launcher.coffee ../../myTopology.json
```
