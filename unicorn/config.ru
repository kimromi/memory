class ShowEnv
  def call(env)
    [ 200,
      { 'Content-Type' => 'text/plain' },
      env.keys.sort.map {|k| "#{k} = #{env[k]}\n" }
    ]
  end
end

run ShowEnv.new
