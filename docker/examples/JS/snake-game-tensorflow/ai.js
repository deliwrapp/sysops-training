var movementOptions = ['left', 'forward', 'right'];

const neuralNet = tf.sequential();
neuralNet.add(tf.layers.dense({units: 256, inputShape: [5]}));
neuralNet.add(tf.layers.dense({units: 512, inputShape: [256]}));
neuralNet.add(tf.layers.dense({units: 256, inputShape: [512]}));
neuralNet.add(tf.layers.dense({units: 3, inputShape: [256]}));

let movementOptionsTensor = tf.tensor1d(movementOptions, 'int32');;
movementOptionsTensor.dispose();


const optAdam = tf.train.adam(.001);
neuralNet.compile({
  optimizer: optAdam,
  loss: 'meanSquaredError'
});


async function trainNeuralNet(moveRecord) {
  console.log(moveRecord);
  for (var i = 0; i < moveRecord.length; i++) {
     const expected = tf.oneHot(tf.tensor1d([deriveExpectedMove(moveRecord[i])], 'int32'), 3).cast('float32');
     posArr = tf.tensor2d([moveRecord[i]]);
     const h = await neuralNet.fit(posArr, expected, {
         batchSize: 3,
         epochs: 1
     });
    //  console.log("Loss after Epoch " + i + " : " + h.history.loss[0]);
     expected.dispose();
     posArr.dispose();
  }
}

function computePrediction(input) {
  let inputs = tf.tensor2d([input]);
  const outputs = neuralNet.predict(inputs);
  return movementOptions[outputs.argMax(1).dataSync()[0]];

}