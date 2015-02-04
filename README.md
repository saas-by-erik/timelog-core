# tl (timelog)

Stack-oriented time tracking.

## Description

`tl` is a command-line utility for logging time and generating reports.

`tl` supports a set of seven commands; `tl init`, `tl timepoint`,
`tl pending`, `tl pop-drop`, `tl merge-add`, `tl unlog` and `tl report`.

### Timestamp format

The timestamp format of `tl timepoint` is
`[<YYYY>-<mm>-<dd>T]<HH>:<MM>`. (Similar to, but not quite, ISO 8601.)

### Time zone

Timestamps are not good for much without a time zone.

Time zone is included in the timestamp as provided by your OS.

The time zone recorded by `tl timepoint` will be used when presenting
timepoints (such as by `tl pending` and `tl report`).

## Supported platforms

`tl` is being developed on FreeBSD/armv6, FreeBSD/amd64 and OpenBSD/i386.

## Known issues

* Close to no concern has yet been given to endianness.
* The tests only check the `tl` execution return values.
  They need to be rewritten so that they additionally test the actual outcome.
* Some operating systems, when faced with an invalid `$TZ`, will
  silently ignore it and use UTC.

## Compiling

```
make test
```
