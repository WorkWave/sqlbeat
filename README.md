# Sqlbeat
Fork of [sqlbeat](https://github.com/adibendahan/sqlbeat) for pulling SQL query data into WorkWave Sonar.

`sqlbeat` is a fully customizable Elastic Beat for MySQL/Microsoft SQL Server/PostgreSQL servers - this beat can ship the results of any query defined in the config file to Elasticsearch.

## Current status

Sqlbeat still in beta.

## To Do

* Update to more recent `libbeat` (the current bound version is 5.0.0-snapshot)
* Add SSPI support for MSSQL
* Replace configuration arrays with objects to better support multiple queries
  * Include default settings (apply to all queries unless over-ridden)
  * Run queries at different times
  * Output results to separate `elasticsearch` indexes and types
  * Use separate `elasticsearch` templates for each query
* (Thinking about it) Add option to save connection string in the config file - will open support for all [SQLDrivers](https://github.com/golang/go/wiki/SQLDrivers).
* Add sample queries and template file

## Features

* Connect to MySQL / Microsoft SQL Server / PostgreSQL and run queries
 * `single-row` queries will be translated as columnname:value.
 * `two-columns` will be translated as value-column1:value-column2 for each row.
 * `multiple-rows` each row will be a document (with columnname:value) - no DELTA support.
 * `show-slave-delay` will only send the "Seconds_Behind_Master" column from `SHOW SLAVE STATUS;` (For MySQL use)
* Any column that ends with the delatwildcard (default is __DELTA) will send delta results, extremely useful for server counters.
  `((newval - oldval)/timediff.Seconds())`

# How to Build

Sqlbeat is written in [golang](https://golang.org/).  To build, you will need
to install and configure a golang environment.  

Golang supports cross-compilation.  So while `sqlbeat` is only needed/used 
under windows at WorkWave, you may build `sqlbeat` on any go platform.  

The `Makefile` was developed on a mac, so there may well be unintended
OS dependencies.  If you wish to develop under Windows (not such a bad idea), you
will probably need to install cygwin or similar.  Since `sqlbeat` depends on
`libbeat` (the `Makefile` includes a shared `make` includefile with a bunch
of shared `targets`), you will probably need to install some type of unix environment
on your PC (for example, cygwin).

The `sqlbeat` project uses older versions of some dependent libraries.  `golang`
would prefer to use current versions.  The project uses `glide` to ensure that
the required version of each dependency (including especially `libbeat`) is
installed and referenced.  Be sure to run `glide update` (as described below)
before building or you may run into syntax / version compatibility errors.  There
is a to-do (above) to update `sqlbeat` to a more recent version of `libbeat`.

## Pre-requisites

* Install [Golang](https://golang.org/dl/)
* Install [Glide](https://github.com/Masterminds/glide)
* Install [gnumake](https://stackoverflow.com/questions/32127524/how-to-install-and-use-make-in-windows-8-1) (if not on a unix box)

## Building

After installing the pre-requisites, add this project to your `gopath`.

```
go get github.com/workwave/sqlbeat
```

This will add the project and any `go` dependencies to your `gopath` `src` directory.

Once glide and make are installed, update the dependencies and run `make`.

```
glide update
make 
```

If you see syntax errors from the build, be sure that you have the proper version
of the dependencies -- make sure that `glide update` completes successfully.

## Creating a Distribution

As with other elastic beats, `sqlbeat` is distributed as a zip file that
includes the executable, sample configuration files and a couple of powershell
scripts to help install the executable as a service under windows.

The `makefile` `dist` target uses `golang` `gox` cross-compiler to build the windows executable,
bundles it with the other files and zips it up.  The `makefile` includes a


# Deploying and Running

WorkWave deploys this beat as part of `sonar`.
The configuration files in this project are for testing purposes only.

## Configuration

Edit sqlbeat configuration in ```sqlbeat.yml``` .

You can:
 * Choose DB Type
 * Add queries to the `queries` array
 * Add query types to the `querytypes` array
 * Define Username/Password to connect to the DB server
 * Define the column wild card for delta columns
 * Password can be saved in clear text/AES encryption

Notes on password encryption: Before you compile your own mysqlbeat, you should put a new secret in the code (defined as a const), secret length must be 16, 24 or 32, corresponding to the AES-128, AES-192 or AES-256 algorithm. I recommend deleting the secret from the source code after you have your compiled mysqlbeat. You can encrypt your password with [mysqlbeat-password-encrypter](github.com/adibendahan/mysqlbeat-password-encrypter, "github.com/adibendahan/mysqlbeat-password-encrypter") just update your secret (and commonIV if you choose to change it) and compile.

## Template

 Since Sqlbeat runs custom queries only, a template can't be provided. Once you define the queries you should create your own template.

## Testing

Just run ```sqlbeat -c sqlbeat.yml``` and you are good to go.

# License

The license for the forked repository was an Apache v2 license as of the time
of the fork (August 5, 2017).  The LICENSE is included in this repository for
reference.
