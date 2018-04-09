# Portal

Repo with code written by following the instructions on [how i start](http://howistart.org/posts/elixir/1/), and expanding on its ideas (also using the more updated version of `:simple_one_for_one` in `DynamicSupervisor)


## Usage

```elixir
Portal.shoot(:red)
Portal.shoot(:blue)
portal = Portal.transfer(:red, :blue, [1,2,3,4])
Portal.push_left(portal)
Portal.push_right(portal)
portal
```
