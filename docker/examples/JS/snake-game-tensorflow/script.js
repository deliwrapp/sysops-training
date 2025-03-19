const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');

const scale = 40; 
const rows = 20;
const columns = 20;
const totalCells = rows * columns;
const bitMask = new Uint32Array(Math.ceil(totalCells / 32));
canvas.width = columns * scale;
canvas.height = rows * scale;

const directions = [
    { x: 0, y: -1 },
    { x: 1, y: 0 },
    { x: 0, y: 1 },
    { x: -1, y: 0 }
];

let snake;
let fruit;
let gameInterval;
let gameMode = 'manual';
let model;
let score = 0;
var speedDifficulty = 75;
var posX = 20;
var posY = 20;
var gameSize = 20;
var accelerationX = 15;
var accelerationY = 15;
var velocityX = 0;
var velocityY = 0;
var path=[];
var setTail = 1;
var length = setTail;
var highScore = 0;
var speedDifficulty = 75;
var movementLog = [];
var currGen = 0;
var gameRunning = true;
var direction = ['left', 'forward', 'right'];
var xApple = Math.floor(Math.random()*gameSize);
var yApple = Math.floor(Math.random()*gameSize);
var loopsSinceApple = 0;

document.getElementById('mode').addEventListener('change', function() {
    gameMode = this.value;
});

document.getElementById('startGame').addEventListener('click', function() {
    if (gameMode === 'model') {
        gameSpeed = setInterval(game,speedDifficulty);
    } else {
        startGame();
    }
});

document.getElementById('restartGame').addEventListener('click', function() {
    resetGame();
});

function startGame() {
    score = 0;
    document.getElementById('score').innerText = score;
    document.getElementById('startGame').style.display = 'none';
    document.getElementById('restartGame').style.display = 'inline';
    setup();
}

function setup() {
    snake = [{ x: 5, y: 5 }];
    direction = { x: 1, y: 0 };
    clearBoard();
    setBit(snake[0].x, snake[0].y);
    placeFruit();
    if (gameMode === 'model') {
        gameInterval = setInterval(gameLoopAI, 100);
    } else {
        gameInterval = setInterval(gameLoopManual, 100);
        window.addEventListener('keydown', changeDirection);
    }
}

function placeFruit() {
    let x, y;
    do {
        x = Math.floor(Math.random() * columns);
        y = Math.floor(Math.random() * rows);
    } while (getBit(x, y));
    fruit = { x, y };
    console.log('Fruit placed at:', fruit);
}

function gameLoopManual() {
    const head = { x: snake[0].x + direction.x, y: snake[0].y + direction.y };

    
    if (head.x < 0 || head.x >= columns || head.y < 0 || head.y >= rows) {
        gameOver();
        return;
    }

    if (checkCollision(head)) {
        gameOver();
        return;
    }

    snake.unshift(head);
    setBit(head.x, head.y);

    if (head.x === fruit.x && head.y === fruit.y) {
        score++;
        document.getElementById('score').innerText = score;
        placeFruit();
    } else {
        const tail = snake.pop();
        clearBit(tail.x, tail.y);
    }
    
    draw();
}

function checkCollision(head) {
    return getBit(head.x, head.y) && !(head.x === snake[1]?.x && head.y === snake[1]?.y);
}

function changeDirection(event) {
    const { keyCode } = event;
    if (keyCode === 37 && direction.x === 0) {
        direction = { x: -1, y: 0 };
    } else if (keyCode === 38 && direction.y === 0) {
        direction = { x: 0, y: -1 };
    } else if (keyCode === 39 && direction.x === 0) {
        direction = { x: 1, y: 0 };
    } else if (keyCode === 40 && direction.y === 0) {
        direction = { x: 0, y: 1 };
    }
}

function reloadGame(event) {
    if (event.keyCode === 13) { 
        window.removeEventListener('keydown', reloadGame);
        setup();
    }
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.fillStyle = '#6200ea';
    snake.forEach(segment => {
        ctx.fillRect(segment.x * scale, segment.y * scale, scale, scale);
    });
    ctx.fillStyle = 'red';
    ctx.fillRect(fruit.x * scale, fruit.y * scale, scale, scale);
}

function setBit(x, y) {
    const index = y * columns + x;
    const arrayIndex = Math.floor(index / 32);
    const bitIndex = index % 32;
    bitMask[arrayIndex] |= 1 << bitIndex;
}

function clearBit(x, y) {
    const index = y * columns + x;
    const arrayIndex = Math.floor(index / 32);
    const bitIndex = index % 32;
    bitMask[arrayIndex] &= ~(1 << bitIndex);
}

function getBit(x, y) {
    const index = y * columns + x;
    const arrayIndex = Math.floor(index / 32);
    const bitIndex = index % 32;
    return (bitMask[arrayIndex] & (1 << bitIndex)) !== 0;
}

function clearBoard() {
    bitMask.fill(0);
}

function gameOver() {
    clearInterval(gameInterval);
    window.removeEventListener('keydown', changeDirection);
    alert('Game Over. Press Restart to play again.');
}

function resetGame() {
    clearInterval(gameInterval);
    snake = [];
    direction = {};
    document.getElementById('startGame').style.display = 'inline';
    document.getElementById('restartGame').style.display = 'none';
    document.getElementById('modelFile').value = null;
}



function game() {
  posX += velocityX;
  posY += velocityY;

  if (velocityX !== 0 || velocityY !== 0) {
      gameRunning = true;
  }

  ctx.fillStyle = "white";
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  ctx.fillStyle = "#6200ea";
  path.forEach(segment => {
      ctx.fillRect(segment.x * scale, segment.y * scale, scale - 2, scale - 2);
      if (gameRunning && segment.x === posX && segment.y === posY) {
          restartGame();
          return;
      }
  });

  path.push({ x: posX, y: posY });
  while (path.length > length) {
      path.shift();
  }

  movementLog.push(getPositionArray());
  processInput(computePrediction(getPositionArray()));

  if (posX < 0 || posX >= columns || posY < 0 || posY >= rows) {
      restartGame();
      return;
  }

  if (loopsSinceApple >= 75) {
      restartGame();
      return;
  }

  if (xApple === posX && yApple === posY) {
      loopsSinceApple = 0;
      length++;
      score++;
      placeApple();
  }

  ctx.fillStyle = "red";
  ctx.fillRect(xApple * scale, yApple * scale, scale - 2, scale - 2);

  document.getElementById("score").innerText = score;
  document.getElementById("genCount").innerText = currGen;

  loopsSinceApple++;
}

function placeApple() {
  xApple = Math.floor(Math.random() * columns);
  yApple = Math.floor(Math.random() * rows);
}

function processInput(input) {

    if ( input == 'left') {
      if (velocityY == -1) { 
        velocityX = -1;
        velocityY = 0;
      } else if ( velocityY == 1) {
        velocityX = 1;
        velocityY = 0;
      } else if ( velocityX == -1) {
        velocityX = 0;
        velocityY = 1;
      } else {
        velocityX = 0;
        velocityY = -1;
      }

    } else if ( input == 'right'){
      if (velocityY == -1) { 
        velocityX = 1;
        velocityY = 0;
      } else if ( velocityY == 1) {
        velocityX = -1;
        velocityY = 0;
      } else if ( velocityX == -1) {
        velocityX = 0;
        velocityY = -1;
      } else {
        velocityX = 0;
        velocityY = 1;
      }
    } else if ( input == 'forward'){
      if ( velocityY == 0 && velocityX == 0) {
        velocityY = -1;
      }
    }
}
function restartGame() {
   gameRunning = false;
   if ( score > highScore) {
     highScore = score;
     document.getElementById("highScore").innerHTML = highScore;
   }
   length = setTail;
   score = 0;
   velocityX = 0;
   velocityY = 0;
   posX = 10;
   posY = 10;
   currGen++;
   trainNeuralNet(movementLog);
   loopsSinceApple = 0;
   movementLog = [];
}

function getPositionArray() {
  var arr = [0,0,0];
  var relApple = [0,0];
  if ( velocityY == -1 ) {

    if ( xApple < posX) {
      relApple[0] = -1;
    } else if (xApple == posX) {
      relApple[0] = 0;
    } else {
      relApple[0] = 1;
    }

    if ( yApple < posY) {
      relApple[1] = 1;
    } else if ( yApple == posY) {
      relApple[1] = 0;
    } else {
      relApple[1] = -1;
    }

    if ( posX == 0) {
      arr[0] = 1;
    }
    if ( posY == 0) {
      arr[1] = 1;

    }
    if ( posX == gameSize - 1) {
      arr[2] = 1;
    }
    for ( var i = 0; i < path.length; i++) {
      if ( path[i].x == posX - 1 && path[i].y == posY) {
        arr[0] = 1;
      }
      if ( path[i].x == posX && path[i].y == posY - 1) {
        arr[1] = 1;
      }
      if ( path[i].x == posX + 1 && path[i].y == posY) {
        arr[2] = 1;
      }
    }

  } else if ( velocityY == 1) {
    if ( xApple < posX) {
      relApple[0] = 1;
    } else if (xApple == posX) {
      relApple[0] = 0;
    } else {
      relApple[0] = -1;
    }

    if ( yApple < posY) {
      relApple[1] = -1;
    } else if ( yApple == posY) {
      relApple[1] = 0;
    } else {
      relApple[1] = 1;
    }

    if ( posX == gameSize - 1) {
      arr[0] = 1;
    }
    if ( posY == gameSize - 1) {
      arr[1] = 1;
    }
    if ( posX == 0) {
      arr[2] = 1;
    }
    for ( var i = 0; i < path.length; i++) {

      if ( path[i].x == posX + 1 && path[i].y == posY) {
        arr[0] = 1;
      }
      if ( path[i].x == posX && path[i].y == posY + 1) {
        arr[1] = 1;
      }

      if ( path[i].x == posX - 1 && path[i].y == posY) {
        arr[2] = 1;
      }
    }

  } else if ( velocityX == -1) {

    if ( xApple < posX) {
      relApple[1] = -1;
    } else if (xApple == posX) {
      relApple[1] = 0;
    } else {
      relApple[1] = 1;
    }

    if ( yApple < posY) {
      relApple[0] = 1;
    } else if ( yApple == posY) {
      relApple[0] = 0;
    } else {
      relApple[0] = -1;
    }

    if ( posY == gameSize - 1) {
      arr[0] = 1;
    }
    if ( posX == 0) {
      arr[1] = 1;
    }
    if ( posY == 0) {
      arr[2] = 1;
    }
    for ( var i = 0; i < path.length; i++) {

      if ( path[i].x == posX && path[i].y == posY + 1) {
        arr[0] = 1;
      }

      if ( path[i].x == posX - 1 && path[i].y == posY) {
        arr[1] = 1;
      }

      if ( path[i].x == posX && path[i].y == posY - 1) {
        arr[2] = 1;
      }
    }
  } else if ( velocityX == 1){

    if ( xApple < posX) {
      relApple[1] = 1;
    } else if (xApple == posX) {
      relApple[1] = 0;
    } else {
      relApple[1] = -1;
    }

    if ( yApple < posY) {
      relApple[0] = -1;
    } else if ( yApple == posY) {
      relApple[0] = 0;
    } else {
      relApple[0] = 1;
    }

    if ( posY == 0) {
      arr[0] = 1;
    }
    if ( posX == gameSize - 1) {
      arr[1] = 1;
    }
    if ( posY == gameSize - 1) {
      arr[2] = 1;
    }


    for ( var i = 0; i < path.length; i++) {

      if ( path[i].x == posX && path[i].y == posY - 1) {
        arr[0] = 1;
      }

      if ( path[i].x == posX + 1 && path[i].y == posY) {
        arr[1] = 1;
      }
      if ( path[i].x == posX && path[i].y == posY + 1) {
        arr[2] = 1;
      }
    }
  } else {
    
    if ( xApple < posX) {
      relApple[0] = -1;
    } else if (xApple == posX) {
      relApple[0] = 0;
    } else {
      relApple[0] = 1;
    }

    if ( yApple < posY) {
      relApple[1] = -1;
    } else if ( yApple == posY) {
      relApple[1] = 0;
    } else {
      relApple[1] = 1;
    }
  }

  arr.push(relApple[0]);
  arr.push(relApple[1]);
  
  
  return arr;
}

function deriveExpectedMove(arr) {
  
  if ( arr[0] == 1 && arr[1] == 1) {
    return 2;
  
  } else if (arr[0] == 1 && arr[2] == 1) {
    return 1;
  
  } else if (arr[1] == 1 && arr[2] == 1) {
    return 0;
  
  } else if ( arr[0] == 1 && (arr[3] == -1 || arr[3] == 0)) {
    
    if (arr[4] == -1) {
      return 2;
    } else {
      return 1;
    }
  
  } else if (arr[0] == 1 && arr[3] == 1) {
    return 2;
  
  }  else if (arr[1] == 1 && (arr[3] = -1 )|| arr[3] == 0) {
    return 0;
  
  } else if (arr[1] == 1 && arr[3] == 1) {
    return 2;
  
  } else if (arr[2] == 1 && arr[3] == -1) {
    return 0;
  
  } else if (arr[2] == 1 && arr[3]== 0){
    
    if (arr[4]== -1){
      return 0;
    } else {
      return 1;
    }
  
  } else if (arr[2] == 1 && arr[3]== 1) {
    return 1;
    
  } else if (arr[3] == -1) {
    return 0;
  
  } else if (arr[3] == 0) {
    
    if ( arr[4] == -1) {
      return 0;
    
    } else {
      return 1;
    }
  
  } else {
    return 2;
  }
}