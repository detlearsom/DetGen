## Datasets

Using DetGen, we have generated the following datasets:

1. **DetGen-IDS:**
Moving towards a more general dataset constructed to apply this probing methodology, we constructed *DetGen-IDS*. This dataset is suitable to quickly probe ML-model behaviour that were trained on the CICIDS-17 dataset. The dataset mirrors properties of the CICIDS-17 data to allow pre-trained models to be probed without retraining. The *DetGen-IDS* data therefore serves as complementary probing data that provides microstructure labels and a sufficient and controlled diversity of several traffic characteristics that is not found in the CICIDS-17 data.

2. **Stepping-stone dataset:**
The detection of interactive stepping-stones is challenging due to various reasons. Like many intrusion attacks, stepping-stones are rare and there exist no public datasets, leading researchers to evaluate their methods on self-provided private data, which makes a direct comparison of the achieved results impossible. We release a large and comprehensive dataset suitable for the training of machine-learning-based methods and in-depth performance evaluation. To our knowledge, this is the first public SSD dataset.

Both datasets are currently being uploaded to our [**data repository**](https://groups.inf.ed.ac.uk/security/detgen/), where they will be available to other researchers. 

