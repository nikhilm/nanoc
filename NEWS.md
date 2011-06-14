# nanoc news

## 3.2 (???)

Base:

* Sped up nanoc quite a bit
* Added progress indicator for long-running filters
* Made all source data, such as item attributes, frozen during compilation
* Added --color option to forhace color on
* Cleaned up internals, deprecating several parts and/or marking them as
  private in the progress

Extensions:

* Added AsciiDoc filter
* Added Redcarpet filter [Peter Aronoff]
* Added Typogruby filter
* Added Slim filter [Zaiste de Grengolada]
* Added :items parameter for the XML site map [Justin Hileman]
* Added support for params to ERB
* Allowed for passing arbitrary options to pygmentize [Matthias Vallentin]
* Exposed RedCloth parameters in the filter [Vincent Driessen]

## 3.1.7 (2011-05-03)

* Restored compatibility with Sass 3.1

## 3.1.6 (2010-11-21)

* Fixed issues with incompatible encodings

## 3.1.5 (2010-08-24)

* Improved `#render` documentation
* Improved metadata section check so that e.g. raw diffs are handled properly
* Deprecated using `Nanoc3::Site#initialize` with a non-`"."` argument
* Added Ruby engine to version string
* Allowed the `created_at` and `updated_at` attributes used in the `Blogging`
  helper to be `Date` instances

## 3.1.4 (2010-07-25)

* Made INT and TERM signals always quit the CLI
* Allowed relative imports in LESS
* Made sure modification times are unchanged for identical recompiled items
* Improved link validator error handling
* Made pygmentize not output extra divs and pres
* Allowed colorizers to be specified using symbols instead of strings
* Added scss to the default list of text extensions

## 3.1.3 (2010-04-25)

* Removed annoying win32console warning [Eric Sunshine]
* Removed color codes when not writing to a terminal, or when writing to
  Windows’ console when win32console is not installed [Eric Sunshine]
* Added .xhtml and .xml to list of text extensions
* Improved support for relative Sass @imports [Chris Eppstein]

## 3.1.2 (2010-04-07)

* Fixed bug which could cause incorrect output when compilation of an item is
  delayed due to an unmet dependency

## 3.1.1 (2010-04-05)

* Sass `@import`s now work for files not managed by nanoc
* Rake tasks now have their Unicode description decomposed if necessary

## 3.1 (2010-04-03)

New:

* An `Item#rep_named(name)` function for quickly getting a certain rep
* An `Item#compiled_content` function for quickly getting compiled content
* An `Item#path` function for quickly getting the path of an item rep
* A new “+” wildcard in rule patterns that matches one or more characters
* A `view` command that starts a web server in the output directory
* A `debug` command that shows information about the items, reps and layouts
* A `kramdown` filter ([kramdown site](http://kramdown.rubyforge.org/))
* A diff between the previously compiled content and the last compiled content
  is now written to `output.diff` if the `enable_output_diff` site
  configuration attribute is true
* Assigns, such as `@items`, `@layouts`, `@item`, … are accessible without `@`
* Support for binary items

Changed:

* New sites now come with a stylesheet item instead of a `style.css` file in
  the output directory
* The `deploy:rsync` task now use sensible default options
* The `deploy:rsync` task now accepts a config environment variable
* The `deploy:rsync` task now uses a lowercase `dry_run` environment variable
* The `maruku` filter now accepts parameters
* The `rainpress` filter now accepts parameters
* The `filesystem` data source is now known as `filesystem_verbose`
* Meta files and content files are now optional
* The `filesystem_compact` and `filesystem_combined` data sources have been
  merged into a new `filesystem_unified` data source
* The metadata section in `filesystem_unified` is now optional [Christopher
  Eppstein]
* The `--server` autocompile option is now known as `--handler`
* Assigns in filters are now available as instance variables and methods
* The `#breadcrumbs_trail` function now allows missing parents
* The `sass` filter now properly handles `@import` dependencies

Deprecated:

* `Nanoc3::FileProxy`; use one of the filename attributes instead
* `ItemRep#content_at_snapshot`; use `#compiled_content` instead
* The `last_fm`, `delicious` and `twitter` data sources; fetch online content
  into a cache by a rake task and load data from this cache instead

## 3.0.9 (2010-02-24)

* Fixed 1.8.x parsing bug due to lack of parens which could cause “undefined
  method `to_iso8601_time` for #<String:0x…>” errors

## 3.0.8 (2010-02-24)

* `#atom_tag_for` now works with base_urls that contain a path [Eric Sunshine]
* Generated root URLs in `#atom_feed` now end with a slash [Eric Sunshine]
* Autocompiler now recognises requests to index files
* `Blogging` helper now allows created_at to be a Time instance

## 3.0.7 (2010-01-29)

* Fixed bug which could cause layout rules not be matched in order

## 3.0.6 (2010-01-17)

* Error checking in `filesystem_combined` has been improved [Brian Candler]
* Generated HTML files now have a default encoding of UTF-8
* Periods in identifiers for layouts now behave correctly
* The `relativize_paths` filter now correctly handles “/” [Eric Sunshine]

## 3.0.5 (2010-01-12)

* Restored pre-3.0.3 behaviour of periods in identifiers. By default, a file
  can have multiple extensions (e.g. `content/foo.html.erb` will have the
  identifier `/foo/`), but if `allow_periods_in_identifiers` in the site
  configuration is true, a file can have only one extension (e.g.
  `content/blog/stuff.entry.html` will have the identifier
  `/blog/stuff.entry/`).

## 3.0.4 (2010-01-07)

* Fixed a bug which would cause the `filesystem_compact` data source to
  incorrectly determine the content filename, leading to weird “Expected 1
  content file but found 3” errors [Eric Sunshine]

## 3.0.3 (2010-01-06)

* The `Blogging` helper now properly handles item reps without paths
* The `relativize_paths` filter now only operates inside tags
* The autocompiler now handles escaped paths
* The `LinkTo` and `Tagging` helpers now output escaped HTML
* Fixed `played_at` attribute assignment in the `LastFM` data source for
  tracks playing now, and added a `now_playing` attribute [Nicky Peeters]
* The `filesystem_*` data sources can now handle dots in identifiers
* Required enumerator to make sure `#enum_with_index` always works
* `Array#stringify_keys` now properly recurses

## 3.0.2 (2009-11-07)

* Children-only identifier patterns no longer erroneously also match parent
  (e.g.` /foo/*/` no longer matches `/foo/`)
* The `create_site` command no longer uses those ugly HTML entities
* Install message now mentions the IRC channel

## 3.0.1 (2009-10-05)

* The proper exception is now raised when no matching compilation rules can
  be found
* The autocompile command no longer has a duplicate `--port` option
* The `#url_for` and `#feed_url` methods now check the presence of the
  `base_url` site configuration attribute
* Several outdated URLs are now up-to-date
* Error handling has been improved in general

## 3.0 (2009-08-14)

New:

* Multiple data sources
* Dependency tracking between items
* Filters can now optionally take arguments
* `#create_page` and `#create_layout` methods in data sources
* A new way to specify compilation/routing rules using a Rules file
* A `coderay` filter ([CodeRay site](http://coderay.rubychan.de/))
* A `filesystem_compact` data source which uses less directories

Changed:

* Pages and textual assets are now known as “items”

Removed:

* Support for drafts
* Support for binary assets
* Support for templates
* Everything that was deprecated in nanoc 2.x
* `save_*`, `move_*` and `delete_*` methods in data sources
* Processing instructions in metadata

## 2.2.2 (2009-05-18)

* Removed `relativize_paths` filter; use `relativize_paths_in_html` or
  `relativize_paths_in_css` instead
* Fixed bug which could cause nanoc to eat massive amounts of memory when an
  exception occurs
* Fixed bug which would cause nanoc to complain about the open file limit
  being reached when using a large amount of assets

## 2.2.1 (2009-04-08)

* Fixed bug which prevented `relative_path_to` from working
* Split `relativize_paths` filter into two filter: `relativize_paths_in_html`
  and `relativize_paths_in_css`
* Removed bundled mime-types library

## 2.2 (2009-04-06)

New:

* `--pages` and `--assets` compiler options
* `--no-color` commandline option
* `Filtering` helper
* `#relative_path_to` function in `LinkTo` helper
* `rainpress` filter ([Rainpress site](http://code.google.com/p/rainpress/))
* `relativize_paths` filter
* The current layout is now accessible through the `@layout` variable
* Much more informative stack traces when something goes wrong

Changed:

* The commandline option parser is now a lot more reliable
* `#atom_feed` now takes optional `:content_proc`, `:excerpt_proc` and
  `:articles` parameters
* The compile command show non-written items (those with `skip_output: true`)
* The compile command compiles everything by default
* Added `--only-outdated` option to compile only outdated pages

Removed:

* deprecated extension-based code

## 2.1.6 (2009-02-28)

* The `filesystem_combined` data source now supports empty metadata sections
* The `rdoc` filter now works for both RDoc 1.x and 2.x
* The autocompiler now serves a 500 when an exception occurs outside
  compilation
* The autocompiler no longer serves index files when the request path does not
  end with a slash
* The autocompiler now always serves asset content correctly

## 2.1.5 (2009-02-01)

* Added Ruby 1.9 compatibility
* The `filesystem` and `filesystem_combined` data sources now preserve custom
  extensions

## 2.1.4 (2008-11-15)

* Fixed an issue where the autocompiler in Windows would serve broken assets

## 2.1.3 (2008-09-27)

* The `haml` and `sass` filters now correctly take their options from assets
* The autocompiler now serves index files instead of 404s
* Layouts named “index” are now handled correctly
* The `filesystem_combined` data source now properly handles assets

## 2.1.2 (2008-09-08)

* The utocompiler now compiles assets as well
* The `sass` filter now takes options (just like the `haml` filter)
* Haml/Sass options are now taken from the page *rep* instead of the page

## 2.1.1 (2008-08-18)

* Fixed issue which would cause files not to be required in the right order

## 2.1 (2008-08-17)

This is only a short summary of all changes in 2.1. For details, see the
[nanoc web site](http://nanoc.stoneship.org/). Especially the blog and the
updated manual will be useful.

New:

* New `rdiscount` filter ([RDiscount site](http://github.com/rtomayko/rdiscount))
* New `maruku` filter ([Maruku site](http://maruku.rubyforge.org/))
* New `erubis` filter ([Erubis site](http://www.kuwata-lab.com/erubis/))
* A better commandline frontend
* A new filesystem data source named `filesystem_combined`
* Routers, which decide where compiled pages should be written to
* Page/layout mtimes can now be retrieved through `page.mtime`/`layout.mtime`

Changed:

* Already compiled pages will no longer be re-compiled unless outdated
* Layout processors and filters have been merged
* Layouts no longer rely on file extensions to determine the layout processor
* Greatly improved source code documentation
* Greatly improved unit test suite

Removed:

* Several filters have been removed and replaced by newer filters:
	* `eruby`: use `erb` or `erubis` instead
	* `markdown`: use `bluecloth`, `rdiscount` or `maruku` instead
	* `textile`: use `redcloth` instead

## 2.0.4 (2008-05-04)

* Fixed `default.rb`’s `#html_escape`
* Updated Haml filter and layout processor so that @page, @pages and @config
  are now available as instance variables instead of local variables

## 2.0.3 (2008-03-25)

* The autocompiler now honors custom paths
* The autocompiler now attempts to serve pages with the most appropriate MIME
  type, instead of always serving everything as `text/html`

## 2.0.2 (2008-01-26)

* nanoc now requires Ruby 1.8.5 instead of 1.8.6

## 2.0.1 (2008-01-21)

* Fixed a “too many open files” error that could appear during (auto)compiling

## 2.0 (2007-12-25)

New:

* Support for custom layout processors
* Support for custom data sources
* Database data source
* An auto-compiler
* Pages have `parent` and `children`

Changed:

* The source has been restructured and cleaned up a great deal
* Filters are defined in a different way now
* The `eruby` filter now uses ERB instead of Erubis

Removed:

* The `filters` property; use `filters_pre` instead
* Support for Liquid

## 1.6.2 (2007-10-23)

* Fixed an issue which prevented the content capturing plugin from working

## 1.6.1 (2007-10-14)

* Removed a stray debug message

## 1.6 (2007-10-13)

* Added support for post-layout filters
* Added support for getting a File object for the page, so you can now e.g.
  easily get the modification time for a given page (`@page.file.mtime`)
* Cleaned up the source code a lot
* Removed deprecated asset-copying functionality

## 1.5 (2007-09-10)

* Added support for custom filters
* Improved Liquid support -- Liquid is now a first-class nanoc citizen
* Deprecated assets -- use something like rsync instead
* Added `eruby_engine` option, which can be `erb` or `erubis`

## 1.4 (2007-07-06)

* nanoc now supports ERB (as well as Erubis); Erubis no longer is a dependency
* `meta.yaml` can now have `haml_options` property, which is passed to Haml
* Pages can now have a `filename` property, which defaults to `index` [Dennis
  Sutch]
* Pages now know in what order they should be compiled, eliminating the need
  for custom page ordering [Dennis Sutch]

## 1.3.1 (2007-06-30)

* The contents of the `assets` directory are now copied into the output
  directory specified in `config.yaml`

## 1.3 (2007-06-24)

* The `@pages` array now also contains uncompiled pages
* Pages with `skip_output` set to true will not be outputted
* Added new filters
	* Textile/RedCloth
	* Sass
* nanoc now warns before overwriting in `create_site`, `create_page` and
  `create_template` (but not in compile)

## 1.2 (2007-06-05)

* Sites now have an `assets` directory, whose contents are copied to the
  `output` directory when compiling [Soryu]
* Added support for non-eRuby layouts (Markaby, Haml, Liquid, …)
* Added more filters (Markaby, Haml, Liquid, RDoc [Dmitry Bilunov])
* Improved error reporting
* Accessing page attributes using instance variables, and not through `@page`,
  is no longer possible
* Page attributes can now be accessed using dot notation, i.e. `@page.title`
  as well as `@page[:title]`

## 1.1.3 (2007-05-18)

* Fixed bug which would cause layoutless pages to be outputted incorrectly

## 1.1.2 (2007-05-17)

* Backup files (files ending with a “~”) are now ignored
* Fixed bug which would cause subpages not to be generated correctly

## 1.1 (2007-05-08)

* Added support for nested layouts
* Added coloured logging
* `@page` now hold the page that is currently being processed
* Index files are now called “content” files and are now named after the
  directory they are in [Colin Barrett]
* It is now possible to access `@page` in the page’s content file

## 1.0.1 (2007-05-05)

* Fixed a bug which would cause a “no such template” error to be displayed
  when the template existed but compiling it would raise an exception
* Fixed bug which would cause pages not to be sorted by order before compiling

## 1.0 (2007-05-03)

* Initial release
