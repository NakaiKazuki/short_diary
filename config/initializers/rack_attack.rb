class Rack::Attack
  throttle('req/ip', limit: 120, period: 2.minutes, &:ip)
end
