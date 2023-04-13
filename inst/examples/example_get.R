
yaml <- "
default:
  trials: 5
  dataset: 'data-sampled.csv'

production:
  trials: 30
  dataset: 'data.csv'
"

get <- base::get



with_config(yaml, config::get())
with_config(yaml, config::get("trials"))

