from prometheus_client import start_http_server, Gauge
import time
import subprocess
import re

# Define Prometheus metrics
# Fake failed status
fake_rdma_device_status = Gauge('rdma_device_status', '', ['rdma_device', 'net_device'])
fake_rttcc_status = Gauge('rttcc_status', '', ['rdma_device', 'net_device'])

def get_rdma_metrics():
    hostname = subprocess.getoutput("hostname")
    mlx_rdma = subprocess.getoutput("rdma link show | grep rdma | cut -d ' ' -f2,8 | sed 's/\/1//g' | tr '\n' ' '").split()
    fakelink = "mlx5_{digit}".format(digit=re.findall('\d', hostname)[0])
    for i in range(0, len(mlx_rdma), 2):
      mlx = mlx_rdma[i] 
      rdma = mlx_rdma[i+1]
      fake_rttcc_status.labels(rdma_device=rdma, net_device=mlx).set(1)
      if fakelink==mlx:
        fake_rdma_device_status.labels(rdma_device=rdma, net_device=mlx).set(0)
      else:
        fake_rdma_device_status.labels(rdma_device=rdma, net_device=mlx).set(1)


if __name__ == '__main__':
    # Start up the server to expose the metrics.
    start_http_server(9700)
    # Generate RDMA metrics every 10 seconds
    while True:
        get_rdma_metrics()
        time.sleep(10)
