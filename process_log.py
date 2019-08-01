#import os
import sys

if len(sys.argv) != 3:
  print 'Usage: python graph_results.py <filename> <output_tsv>'
  sys.exit(1)

results = []

infile = open(sys.argv[1], 'r')
protocol = None
downlink = None
uplink = None
throughput = None
delay = "0"
avg_capacity = None
avg_delay = None
down = None
up = None
delay_95th = None
delay_99th = None
for line in infile:
  l = line.strip()
  if l in ['Codel', 'TailDrop', 'HeadDrop', 'Pie','BoDe']:
    if not avg_capacity is None:
      results.append((protocol, down, throughput, delay_99th, delay_95th, avg_delay,avg_capacity ))
      protocol = None
      downlink = None
      uplink = None
      throughput = None
      delay = "0"
      avg_capacity = None
      avg_delay = None
    protocol = l
#    down = l.split(':')[1].strip().split(' ')[0]

  elif l.startswith('Average throughput:'):
    throughput = l.split(':')[1].strip().split(' ')[0]
  elif l.startswith('99th percentile per-packet queueing delay:'):
    delay_99th = l.split(':')[1].strip().split(' ')[0]
  elif l.startswith('95th percentile per-packet queueing delay:'):
    delay_95th = l.split(':')[1].strip().split(' ')[0]
  elif l.startswith('95th percentile signal delay:'):
    delay = l.split(':')[1].strip().split(' ')[0]
  elif l.startswith('Average capacity:'):
    avg_capacity = l.split(':')[1].strip().split(' ')[0]
  elif l.startswith('average per packet delay:'):
    avg_delay = l.split(':')[1].strip().split(' ')[0]
  down = sys.argv[1]

if not avg_capacity is None:
  results.append((protocol, down, throughput, delay_99th, delay_95th,avg_delay,avg_capacity))

# now write it out nicely formatted
outfile = open(sys.argv[2], 'w')
outfile.write('protocol\tdown\tthroughput\tdelay_99th\tdelay_95th\tavg_delay\tavg_capacity\n')
for result in results:
  print result
  outfile.write('\t'.join(result))
  outfile.write('\n')
outfile.close()
