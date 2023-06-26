import yaml
import sys

batch_size = int(sys.argv[1])

with open("DDSP-SVC/configs/combsub.yaml", "r") as file:
    data = yaml.safe_load(file)

data['data']['encoder'] = "contentvec"
data['data']['encoder_out_channels'] = 256
data['data']['encoder_ckpt'] = "pretrain/contentvec/checkpoint_best_legacy_500.pt"
data['train']['cache_device'] = "cuda"
data['train']['num_workers'] = 2
data['train']['batch_size'] = batch_size


with open("DDSP-SVC/configs/combsub.yaml", "w") as file:
    yaml.safe_dump(data, file)