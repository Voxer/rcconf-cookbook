Chef::CookbookVersion.class_eval do

  alias_method :load_recipe_without_inline_recipe, :load_recipe

  def load_recipe(recipe_name, run_context)
    runner = run_context.node.runner
    recipe_body = runner.virtual_recipes["#{name}::#{recipe_name}"]
    if recipe_body
      recipe = Chef::Recipe.new(name, recipe_name, run_context)
      recipe.instance_eval(&recipe_body)
      return recipe
    else
      return load_recipe_without_inline_recipe(recipe_name, run_context)
    end
  end

end

ChefSpec::Runner.class_eval do

  def virtual_recipes
    @virtual_recipes ||= {}
  end

  def define_recipe(name, &block)
    raise ArgumentError, 'define_recipe must follow cookbook::recipe_name format' unless name.include?('::')
    virtual_recipes[name] = block
    self
  end

  def converge_virtual_recipe(name, &block)
    name = "#{name}::chefspec-inlined-#{rand(1_000_000)}" unless name.include? '::'
    define_recipe(name, &block)
    converge(name)
  end

end
