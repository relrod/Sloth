Targets are what gets triggered when a Service pokes a server class. It can be thought of as the "end result."

Including a target
==================

Because targets can vary so greatly, it's impossible to cover every single setup.

Below is how you might set up the included IRC Target.

In config.yaml, under the 'targets' section, place the following lines:

    irc:
        server: irc.freenode.net
        port: 6667
        channels: ##codeblock-commits
        nick: codeblock-util
        service: heroku github bitbucket mycustomservice

        Currently it is only possible to include one instance of the same kind of target. For example, it is not possible to create two IRC targets on two separate IRC networks. This will hopefully change sooner than later, as this can be limiting.

Building a target
=================

Sloth targets extend the SlothTarget class.There are several reasons for doing this, but just follow the convention for better or for worse.

As with services, you can override self.immediately to make a target do something as soon as it's loaded. Following the IRC example, this is where you'd connect to a server and join channels to idle in.


The most important method of a target is the activate method. This method **MUST** exist, and should be the absolute final result. In the case of our IRC example, you should expect something like this:

    def activate(text)
      @bot.announce text
    end

Most targets should also have an initialize method, which should be used in the standard ruby form and expect one hash: config key => config value. Assign these to @instance @variables to use them throughout the target.

