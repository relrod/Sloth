A **service** is a "listener" for Sloth -- something that listens on a route.

For example, the Heroku service listens on `/heroku`.

How to include one
==================

Including a service to be used should be as simple as adding the following line in config.yaml, under 'services'.

    heroku: /heroku

Where the first instance of 'heroku' is the name of the file (without the .rb extension) and lower name of the class that the file contains, in services/.

After the `:` is the route to the service. Meaning that if the service were to load /heroku and POST data to it, the serivce class would handle it appropriately.

While it's not a good method for ensuring security, you can be creative with your routes, in order to make it harder for non-services to guess the path.


How to build one
================

A service, at its core, is just a ruby class that extends SlothService.

If there is anything the service needs to do immediately as it is loaded into Sloth, for example authenticating, or ensuring that a website is up, you can optionally define the `self.immediately` method.

Here's an example implementation. This does not actually parse incoming data, but is an example to show the interface.

    class Heroku < SlothService

      self.immediately
        super
        puts 'Sample override of self.immediately.'
      end

      def do_GET(request, response)
        response.body = 'I work.'
        raise HTTPStatus::OK
      end
       
      def to_text
        # This method is what actually gets sent out to the targets.
        return "#{@committer} has just committed revision #{@revision} to #{@appname}."
      end
        
    end

