# NAME

Dancer2::Template::DTLFast - DTL::Fast engine for Dancer2

# VERSION

version 0.002

# SYNOPSIS

In your dancer2 config:

    template: "DTLFast"

In `MyApp.pm`
    get '/foo' => sub {
        template foo, {
            title => 'bar',
        };
    };

In `views/foo.tt`

    <h1>{{ title }}</h1>
    <p>Hello World!</p>

# DESCRIPTION

Dancer2::Template::DTLFast is a template engine that allows you to use
[DTL::Fast](https://metacpan.org/pod/DTL::Fast) with [Dancer2](https://metacpan.org/pod/Dancer2).

The template engine uses the DTL::Fast method get\_template to find the template
and then render it.

In order to use this engine, set the template to 'DTLFast' in the Dancer2
configuration file:

    template: "DTLFast"

The extension for your template files is controlled via Dancer2 and defaults to '.tt'.


# CONFIGURATION

The DTLFast plugin uses DTL::Fast's get\_template method to find the correct template.
The template\_path parameter is populated using the template passed in from Dancer 2;
the following example would pass 'bar' on to get\_template as the 'template\_path':

    get '/foo' => sub { template 'bar', { title => 'layout title' } };

Additional paramters can also be passed to get\_template via the configuration file, 
for example, you can disable DTL::Fast's caching of templates like so:

    engines:
      template:
         DTLFast:
           no_cache: 1

Which would create a hash containing: 

    { 'no\_cache' => 1 }

That hash is then passed on to get\_templates in list context, allowing you to pass
in dirs, ssi\_dirs, url\_source, etc, should you need to.

By default, the dirs parameter is set to the `views` directory configuration setting or,
if it is undefined, to the `views/` subdirectory of the application. You can override
it via the configuration file.


# NOTES

If you want to change the layout for a given request, either set the layout before making
the template request, or pass in the layout key as a *token* not as an option. Otherwise
the template render will be unable to see what template you are requesting and will go
with whatever may be the default. A value passed in as a token takes priority over any
other layout setting.


# SEE ALSO

[Dancer2](https://metacpan.org/pod/Dancer2), [DTL::Fast](https://metacpan.org/pod/DTL::Fast)

# AUTHOR

Carl Blakemore <carlblakemore@gmail.com>

# LICENSE

Copyright (C) Carl Blakemore.

This library is free software; you can redistribute it and/or modify
it under the MIT License (MIT).
