while true; do
  timestamp=$(date +%s)
  job="YourGuide"
  instance="TimeStamp"
  echo "trial_metric $timestamp; Job: $job; Instance: $instance;"
  echo "trial_metric $timestamp" | curl --data-binary @- http://localhost:9091/metrics/job/$job/instance/$instance
  sleep 1
done

