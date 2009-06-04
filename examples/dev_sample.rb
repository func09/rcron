# start DSL
rcron do

  # 毎分
  job '* * * * *' do
    p 'job test * * * * *'
  end

  # ２分間隔
  job '*/2 * * * *' do
    p 'job test */2 * * * *'
  end
  
end

