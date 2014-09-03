rc.conf
=======

A chef HWRP for manipulating `rc.conf(5)` on FreeBSD machines.

Usage
-----

``` ruby
rcconf 'some_key' do
  value 'some_value'
end
```

This will yield the following line added to `/etc/rc.conf`

```
some_key="some_value"
```

---

``` ruby
rcconf 'Explicit Example' do
  key 'some_other_key'
  value 'this has "quotes" in it'
end
```

yields

```
some_other_key="this has \"quotes\" in it"
```

Any value passed in will be run through `.to_s.inspect` to be stringified
and quoted safely.

---

You can use `:create_if_missing` to add the key to the config if it is
not already present.

``` ruby
rcconf 'Create Foobar if_missing' do
  key 'foobar'
  value 'baz'
  action :create_if_missing
end
```

And finally, you can remove values with:

``` ruby
rcconf 'foobar' do
  action :remove
end
```

Tests
-----

```
$ rspec
..............................................

Finished in 0.57853 seconds (files took 2.53 seconds to load)
46 examples, 0 failures

ChefSpec Coverage report generated...

  Total Resources:   38
  Touched Resources: 38
  Touch Coverage:    100.0%

You are awesome and so is your test coverage! Have a fantastic day!
```

You can also look at the [recipes/test.rb](recipes/test.rb) file
for more examples.

License
-------

MIT License

```
Copyright: 2014, Voxer, Inc

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
