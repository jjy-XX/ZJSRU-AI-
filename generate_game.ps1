$part1 = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>福启新春 - 国风解谜游戏</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: linear-gradient(135deg, #1a0a1a 0%, #2d1f2d 50%, #1a0a1a 100%);
            overflow: hidden;
            font-family: "SimHei", "Microsoft YaHei", "PingFang SC", sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        #gameCanvas {
            display: block;
            margin: 0 auto;
            border: 4px solid #ffd700;
            border-radius: 15px;
            box-shadow: 0 0 30px rgba(255, 215, 0, 0.3), 0 0 60px rgba(255, 102, 0, 0.2);
        }
        #uiLayer { position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; }
        .start-screen {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: radial-gradient(ellipse at center top, #3d1f2a 0%, transparent 50%), radial-gradient(ellipse at center bottom, #2a0a1a 0%, transparent 50%), linear-gradient(135deg, #2a0a1a 0%, #4a1a2a 30%, #2a0a1a 70%, #1a050a 100%);
            display: flex; flex-direction: column; justify-content: center; align-items: center;
            z-index: 100; pointer-events: auto;
        }
        .start-title {
            font-size: 80px; color: #ffd700;
            text-shadow: 0 0 20px #ff6600, 0 0 40px #ff3300, 0 0 60px #ffd700, 0 0 80px #ffaa00;
            margin-bottom: 15px; animation: titleGlow 2s ease-in-out infinite;
            letter-spacing: 12px; font-weight: bold;
        }
        .start-subtitle { font-size: 28px; color: #ff9966; margin-bottom: 60px; text-shadow: 0 0 15px rgba(255, 153, 102, 0.6); letter-spacing: 4px; }
        .start-btn {
            padding: 20px 55px; font-size: 28px; color: #fff;
            background: linear-gradient(180deg, #ff6600 0%, #cc3300 50%, #aa2200 100%);
            border: 4px solid #ffd700; border-radius: 65px; cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 0 25px rgba(255, 102, 0, 0.6), 0 0 50px rgba(255, 102, 0, 0.3), inset 0 3px 0 rgba(255, 255, 255, 0.25);
            font-weight: bold; letter-spacing: 6px; position: relative; overflow: hidden;
        }
        .start-btn::before {
            content: ""; position: absolute; top: -50%; left: -50%;
            width: 200%; height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 215, 0, 0.3), transparent);
            transform: rotate(45deg); animation: btnShine 3s ease-in-out infinite;
        }
        .start-btn:hover {
            transform: scale(1.08);
            box-shadow: 0 0 45px rgba(255, 102, 0, 0.9), 0 0 70px rgba(255, 215, 0, 0.6), inset 0 3px 0 rgba(255, 255, 255, 0.35);
            background: linear-gradient(180deg, #ff8833 0%, #dd4400 50%, #bb3300 100%);
        }
        @keyframes titleGlow { 0%,100%{text-shadow:0 0 20px #ff6600,0 0 40px #ff3300,0 0 60px #ffd700;} 50%{text-shadow:0 0 35px #ffd700,0 0 70px #ff6600,0 0 100px #ff3300;} }
        @keyframes btnShine { 0%,100%{transform:translateX(-100%) rotate(45deg);} 50%{transform:translateX(100%) rotate(45deg);} }
        .health-bar { position: absolute; bottom: 25px; left: 25px; width: 300px; height: 28px; background: rgba(0,0,0,0.85); border: 3px solid #ffd700; border-radius: 18px; overflow: hidden; box-shadow: 0 0 20px rgba(255,215,0,0.3); }
        .health-fill { height: 100%; background: linear-gradient(90deg, #ff3333 0%, #ff6666 20%, #ff9933 50%, #ffcc33 80%, #ffdd66 100%); transition: width 0.3s ease; border-radius: 15px; box-shadow: inset 0 -4px 8px rgba(0,0,0,0.3); }
        .health-label { position: absolute; bottom: 58px; left: 25px; color: #ffd700; font-size: 16px; font-weight: bold; text-shadow: 1px 1px 3px #000; letter-spacing: 2px; }
        .progress-panel { position: absolute; top: 25px; left: 25px; background: rgba(0,0,0,0.85); border: 3px solid #ffd700; border-radius: 15px; padding: 15px 22px; box-shadow: 0 0 20px rgba(255,215,0,0.3); min-width: 240px; }
        .progress-title { color: #ffd700; font-size: 15px; font-weight: bold; margin-bottom: 10px; text-shadow: 1px 1px 2px #000; letter-spacing: 1px; }
        .progress-bar { width: 100%; height: 18px; background: #333; border: 2px solid #ffd700; border-radius: 12px; overflow: hidden; margin-bottom: 8px; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, #ffd700 0%, #ffaa00 50%, #ff6600 100%); transition: width 0.5s ease; border-radius: 10px; box-shadow: 0 0 12px rgba(255,215,0,0.6); }
        .progress-text { color: #ffd700; font-size: 14px; text-align: center; font-weight: bold; }
        .inventory-panel { position: absolute; top: 25px; right: 25px; background: rgba(0,0,0,0.85); border: 3px solid #ffd700; border-radius: 15px; padding: 15px; box-shadow: 0 0 20px rgba(255,215,0,0.3); }
        .inventory-title { color: #ffd700; font-size: 15px; font-weight: bold; margin-bottom: 12px; text-align: center; text-shadow: 1px 1px 2px #000; letter-spacing: 2px; }
        .inventory-grid { display: grid; grid-template-columns: repeat(2, 55px); gap: 10px; }
        .inv-item { width: 55px; height: 55px; border: 2px solid #666; border-radius: 12px; background: rgba(255,215,0,0.15); text-align: center; line-height: 55px; font-size: 28px; position: relative; transition: all 0.3s ease; }
        .inv-item:hover { border-color: #ffd700; background: rgba(255,215,0,0.3); transform: scale(1.08); box-shadow: 0 0 15px rgba(255,215,0,0.4); }
        .inv-item .count { position: absolute; bottom: 2px; right: 6px; color: #ffd700; font-size: 14px; font-weight: bold; text-shadow: 1px 1px 2px #000; }
        .fragments-panel { position: absolute; bottom: 25px; right: 25px; background: rgba(0,0,0,0.85); border: 3px solid #ffd700; border-radius: 15px; padding: 12px 20px; box-shadow: 0 0 20px rgba(255,215,0,0.3); }
        .fragments-title { color: #ffd700; font-size: 13px; font-weight: bold; margin-bottom: 8px; text-align: center; text-shadow: 1px 1px 2px #000; }
        .fragments-row { display: flex; gap: 15px; }
        .fragment-item { display: flex; flex-direction: column; align-items: center; gap: 3px; }
        .fragment-icon { font-size: 26px; opacity: 0.3; transition: all 0.3s ease; }
        .fragment-icon.collected { opacity: 1; text-shadow: 0 0 15px rgba(255,215,0,0.8); }
        .fragment-label { font-size: 11px; color: #ffd700; }
        .dialog-box { position: absolute; bottom: 100px; left: 50%; transform: translateX(-50%); background: linear-gradient(135deg, rgba(0,0,0,0.95) 0%, rgba(40,20,20,0.95) 100%); border: 3px solid #ffd700; border-radius: 18px; padding: 20px 40px; max-width: 700px; color: #fff; font-size: 19px; display: none; box-shadow: 0 0 30px rgba(255,215,0,0.5); pointer-events: auto; }
        .dialog-name { color: #ffd700; font-weight: bold; font-size: 22px; margin-bottom: 12px; padding-bottom: 10px; border-bottom: 2px solid rgba(255,215,0,0.4); letter-spacing: 2px; }
        .dialog-content { line-height: 1.7; text-shadow: 1px 1px 2px #000; }
        .game-over { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.95); display: none; flex-direction: column; justify-content: center; align-items: center; z-index: 200; }
        .game-over-title { font-size: 64px; color: #ff3333; margin-bottom: 20px; text-shadow: 0 0 40px #ff0000; animation: shake 0.5s ease-in-out; letter-spacing: 8px; }
        .game-over-sub { font-size: 24px; color: #ff9966; margin-bottom: 45px; }
        .restart-btn { padding: 16px 40px; font-size: 24px; color: #fff; background: linear-gradient(180deg, #cc3300 0%, #aa2200 100%); border: 3px solid #ffd700; border-radius: 40px; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 0 25px rgba(255,102,0,0.6); font-weight: bold; letter-spacing: 4px; }
        .restart-btn:hover { transform: scale(1.08); box-shadow: 0 0 40px rgba(255,102,0,0.9); }
        @keyframes shake { 0%,100%{transform:translateX(0);} 25%{transform:translateX(-15px);} 75%{transform:translateX(15px);} }
        .rhythm-game { position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%); background: linear-gradient(135deg, rgba(0,0,0,0.98) 0%, rgba(30,15,30,0.98) 100%); border: 4px solid #ffd700; border-radius: 30px; padding: 35px; display: none; z-index: 300; box-shadow: 0 0 60px rgba(255,215,0,0.6), 0 0 100px rgba(255,102,0,0.3); }
        .rhythm-title { color: #ffd700; font-size: 30px; text-align: center; margin-bottom: 25px; text-shadow: 0 0 20px #ff6600; letter-spacing: 4px; }
        .rhythm-track { width: 450px; height: 350px; background: linear-gradient(180deg, #1a0a1a 0%, #2a1a2a 100%); border: 3px solid #ffd700; border-radius: 18px; position: relative; overflow: hidden; }
        .rhythm-lane { position: absolute; top: 0; bottom: 0; width: 100px; border-left: 1px solid rgba(255,215,0,0.1); border-right: 1px solid rgba(255,215,0,0.1); }
        .rhythm-hit-zone { position: absolute; bottom: 40px; left: 0; right: 0; height: 5px; background: rgba(255,215,0,0.6); box-shadow: 0 0 15px rgba(255,215,0,0.8); }
        .rhythm-hit-box { position: absolute; bottom: 45px; width: 70px; height: 45px; background: rgba(255,215,0,0.2); border: 3px solid #ffd700; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 32px; color: #ffd700; transition: all 0.1s ease; }
        .rhythm-hit-box.active { background: rgba(255,215,0,0.5); box-shadow: 0 0 20px rgba(255,215,0,0.8); }
        .rhythm-score { color: #ffd700; font-size: 32px; text-align: center; margin-top: 22px; text-shadow: 0 0 15px #ff6600; font-weight: bold; }
        .rhythm-instruction { color: #ff9966; font-size: 16px; text-align: center; margin-top: 12px; }
        .rhythm-exit { display: block; margin: 22px auto 0; padding: 12px 30px; font-size: 18px; color: #fff; background: #aa2200; border: 2px solid #ffd700; border-radius: 30px; cursor: pointer; transition: all 0.3s ease; }
        .rhythm-exit:hover { background: #cc3300; transform: scale(1.05); }
        .level-complete { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.92); display: none; flex-direction: column; justify-content: center; align-items: center; z-index: 200; }
        .level-complete-title { font-size: 64px; color: #ffd700; margin-bottom: 25px; animation: completeGlow 1.5s ease-in-out infinite; text-shadow: 0 0 50px #ff6600; letter-spacing: 8px; }
        .level-complete-sub { font-size: 26px; color: #ff9966; margin-bottom: 50px; text-align: center; max-width: 500px; }
        .next-level-btn { padding: 18px 50px; font-size: 28px; color: #fff; background: linear-gradient(180deg, #0099cc 0%, #006699 100%); border: 4px solid #ffd700; border-radius: 60px; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 0 30px rgba(0,153,204,0.6); font-weight: bold; letter-spacing: 4px; }
        .next-level-btn:hover { transform: scale(1.1); box-shadow: 0 0 50px rgba(0,153,204,0.9); }
        @keyframes completeGlow { 0%,100%{text-shadow:0 0 50px #ff6600,0 0 80px #ffd700;} 50%{text-shadow:0 0 80px #ffd700,0 0 120px #ff6600;} }
        .hint-text { position: absolute; bottom: 85px; left: 50%; transform: translateX(-50%); color: rgba(255,215,0,0.8); font-size: 15px; text-shadow: 1px 1px 3px #000; background: rgba(0,0,0,0.6); padding: 10px 25px; border-radius: 25px; border: 1px solid rgba(255,215,0,0.4); }
        .level-hint { position: absolute; top: 110px; left: 50%; transform: translateX(-50%); color: #ffd700; font-size: 24px; text-shadow: 2px 2px 4px #000; background: rgba(0,0,0,0.8); padding: 12px 35px; border-radius: 30px; border: 2px solid #ffd700; display: none; animation: fadeInOut 3s ease-in-out; }
        @keyframes fadeInOut { 0%{opacity:0;transform:translateX(-50%) translateY(-20px);} 20%{opacity:1;transform:translateX(-50%) translateY(0);} 80%{opacity:1;transform:translateX(-50%) translateY(0);} 100%{opacity:0;transform:translateX(-50%) translateY(20px);} }
        .fragment-notification { position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%); font-size: 48px; color: #ffd700; text-shadow: 0 0 30px #ff6600; animation: fragmentPop 1.5s ease-out; display: none; z-index: 400; }
        @keyframes fragmentPop { 0%{transform:translate(-50%,-50%) scale(0);opacity:0;} 30%{transform:translate(-50%,-50%) scale(1.3);opacity:1;} 50%{transform:translate(-50%,-50%) scale(1);opacity:1;} 100%{transform:translate(-50%,-50%) scale(1.2);opacity:0;} }
    </style>
</head>
<body>
    <canvas id="gameCanvas" width="1200" height="700"></canvas>
    <div id="uiLayer">
        <div class="start-screen" id="startScreen">
            <h1 class="start-title">福启新春</h1>
            <p class="start-subtitle">国风除魔冒险</p>
            <button class="start-btn" id="startBtn">开始游戏</button>
            <p style="color:rgba(255,255,255,0.6);margin-top:40px;font-size:16px;text-align:center;line-height:1.8;"><span style="color:#ffd700;">操作说明：</span><br>方向键/WASD移动 | 空格跳跃（支持二段跳）<br>鼠标点击交互 | 数字键1使用鞭炮 | R键重置关卡</p>
        </div>
        <div class="health-label">体力值</div>
        <div class="health-bar"><div class="health-fill" id="healthFill" style="width:100%;"></div></div>
        <div class="progress-panel">
            <div class="progress-title">任务进度</div>
            <div class="progress-bar"><div class="progress-fill" id="progressFill" style="width:0%;"></div></div>
            <div class="progress-text" id="progressText">0%</div>
        </div>
        <div class="inventory-panel">
            <div class="inventory-title">背包</div>
            <div class="inventory-grid">
                <div class="inv-item" title="鞭炮（数字键1使用）">🧨<span class="count" id="countFirecracker">0</span></div>
                <div class="inv-item" title="护身符">🛡️<span class="count" id="countAmulet">0</span></div>
                <div class="inv-item" title="禄碎片">⚔️<span class="count" id="countLu">0</span></div>
                <div class="inv-item" title="寿碎片">❤️<span class="count" id="countShou">0</span></div>
            </div>
        </div>
        <div class="fragments-panel">
            <div class="fragments-title">福缘碎片</div>
            <div class="fragments-row">
                <div class="fragment-item"><div class="fragment-icon" id="fragmentFu" title="福">福</div><div class="fragment-label">福</div></div>
                <div class="fragment-item"><div class="fragment-icon" id="fragmentLu" title="禄">禄</div><div class="fragment-label">禄</div></div>
                <div class="fragment-item"><div class="fragment-icon" id="fragmentShou" title="寿">寿</div><div class="fragment-label">寿</div></div>
            </div>
        </div>
        <div class="dialog-box" id="dialogBox">
            <div class="dialog-name" id="dialogName">NPC</div>
            <div class="dialog-content" id="dialogContent">对话内容</div>
        </div>
        <div class="game-over" id="gameOver">
            <h2 class="game-over-title">体力耗尽</h2>
            <p class="game-over-sub">福娃需要休息片刻...</p>
            <button class="restart-btn" id="restartBtn">重新挑战</button>
        </div>
        <div class="rhythm-game" id="rhythmGame">
            <div class="rhythm-title">皮影戏台</div>
            <div class="rhythm-track" id="rhythmTrack">
                <div class="rhythm-lane" style="left:25px;"></div><div class="rhythm-lane" style="left:125px;"></div>
                <div class="rhythm-lane" style="left:225px;"></div><div class="rhythm-lane" style="left:325px;"></div>
                <div class="rhythm-hit-zone"></div>
                <div class="rhythm-hit-box" style="left:40px;">↑</div><div class="rhythm-hit-box" style="left:140px;">↓</div>
                <div class="rhythm-hit-box" style="left:240px;">←</div><div class="rhythm-hit-box" style="left:340px;">→</div>
            </div>
            <div class="rhythm-score">得分: <span id="rhythmScoreValue">0</span></div>
            <div class="rhythm-instruction">使用方向键匹配音符，达到500分获得禄碎片！</div>
            <button class="rhythm-exit" id="rhythmExit">退出游戏</button>
        </div>
        <div class="level-complete" id="levelComplete">
            <h2 class="level-complete-title" id="levelCompleteTitle">关卡完成！</h2>
            <p class="level-complete-sub" id="levelCompleteSub">恭喜你完成了本关挑战</p>
            <button class="next-level-btn" id="nextLevelBtn">下一关</button>
        </div>
        <div class="hint-text" id="hintText">提示：R键重置关卡 | 数字键1使用鞭炮 | 点击NPC对话</div>
        <div class="level-hint" id="levelHint"></div>
        <div class="fragment-notification" id="fragmentNotification">🎁</div>
    </div>
"@

$part2 = @"
    <script>
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        let gameState = 'start';
        let currentLevel = 1;
        let health = 100;
        let progress = 0;
        const globalInventory = { firecracker: 0, amulet: 0, lu: 0, shou: 0 };
        const collectedFragments = { fu: false, lu: false, shou: false };
        let particles = [];
        let fireworks = [];
        let entities = [];
        let cameraX = 0;
        let keys = {};
        let fogOpacity = 0.7;
        let player, portal;
        let rhythmNotes = [];
        let rhythmScore = 0;
        let rhythmActive = false;
        let rhythmInterval;
        let lionDancer = null;
        let remainingPhantoms = 0;
        let riftDamageTimer = 0;

        class Player {
            constructor(x, y) {
                this.x = x; this.y = y; this.width = 45; this.height = 65;
                this.velocityX = 0; this.velocityY = 0;
                this.speed = 5; this.jumpForce = -16; this.gravity = 0.7;
                this.isGrounded = false; this.canDoubleJump = true;
                this.facingRight = true; this.animationFrame = 0; this.animationTimer = 0;
            }
            update() {
                if (keys['ArrowLeft'] || keys['KeyA']) { this.velocityX = -this.speed; this.facingRight = false; }
                else if (keys['ArrowRight'] || keys['KeyD']) { this.velocityX = this.speed; this.facingRight = true; }
                else { this.velocityX *= 0.8; if (Math.abs(this.velocityX) < 0.1) this.velocityX = 0; }
                this.velocityY += this.gravity;
                this.x += this.velocityX; this.y += this.velocityY;
                if (this.y > canvas.height - 100) { this.y = canvas.height - 100; this.velocityY = 0; this.isGrounded = true; this.canDoubleJump = true; }
                if (this.x < 0) this.x = 0;
                if (this.x > 3200 - this.width) this.x = 3200 - this.width;
                this.animationTimer++;
                if (this.animationTimer > 6) { this.animationFrame = (this.animationFrame + 1) % 4; this.animationTimer = 0; }
                cameraX = Math.max(0, Math.min(this.x - canvas.width / 2, 3200 - canvas.width));
            }
            jump() {
                if (this.isGrounded) { this.velocityY = this.jumpForce; this.isGrounded = false; createParticles(this.x + this.width/2, this.y + this.height, '#ffd700', 8); playSound('jump'); }
                else if (this.canDoubleJump) { this.velocityY = this.jumpForce * 0.85; this.canDoubleJump = false; createParticles(this.x + this.width/2, this.y + this.height, '#ffaa00', 12); playSound('jump'); }
            }
            draw(ctx) {
                ctx.save(); ctx.translate(this.x - cameraX, this.y);
                if (!this.facingRight) ctx.scale(-1, 1);
                ctx.fillStyle = '#cc0000'; ctx.beginPath(); ctx.roundRect(-22, -35, 44, 65, 12); ctx.fill();
                ctx.fillStyle = '#ffd700'; ctx.fillRect(-22, -30, 44, 4); ctx.fillRect(-22, -10, 44, 4); ctx.fillRect(-22, 10, 44, 4);
                ctx.fillStyle = '#ffddbb'; ctx.beginPath(); ctx.arc(0, -48, 18, 0, Math.PI * 2); ctx.fill();
                ctx.fillStyle = '#2a1a0a'; ctx.beginPath(); ctx.arc(0, -52, 15, Math.PI, 0); ctx.fill();
                ctx.fillStyle = '#cc0000'; ctx.beginPath(); ctx.moveTo(0, -65); ctx.lineTo(-8, -75); ctx.lineTo(8, -75); ctx.closePath(); ctx.fill();
                ctx.fillStyle = '#333'; ctx.beginPath(); ctx.arc(-6, -50, 3, 0, Math.PI * 2); ctx.arc(6, -50, 3, 0, Math.PI * 2); ctx.fill();
                ctx.fillStyle = 'rgba(255,100,100,0.4)'; ctx.beginPath(); ctx.ellipse(-12, -44, 5, 3, 0, 0, Math.PI * 2); ctx.ellipse(12, -44, 5, 3, 0, 0, Math.PI * 2); ctx.fill();
                const legOffset = this.velocityX !== 0 ? Math.sin(this.animationFrame * 0.8) * 8 : 0;
                ctx.fillStyle = '#2a1a0a'; ctx.fillRect(-15, 25, 12, 18); ctx.fillRect(3, 25 + legOffset * 0.5, 12, 18);
                ctx.fillStyle = '#3a2a1a'; ctx.fillRect(-17, 38, 16, 8); ctx.fillRect(1, 38 + legOffset * 0.5, 16, 8);
                ctx.restore();
            }
        }

        class Lantern {
            constructor(x, y) { this.x = x; this.y = y; this.lit = false; this.animationFrame = 0; }
            update() { if (this.lit) this.animationFrame += 0.08; }
            draw(ctx) {
                ctx.save(); ctx.translate(this.x - cameraX, this.y);
                ctx.fillStyle = '#ffd700'; ctx.fillRect(-5, -38, 10, 5);
                if (this.lit) {
                    const glow = Math.sin(this.animationFrame) * 10 + 25;
                    ctx.shadowColor = '#ff6600'; ctx.shadowBlur = glow;
                    ctx.fillStyle = '#ff4400'; ctx.beginPath(); ctx.ellipse(0, 0, 18, 25, 0, 0, Math.PI * 2); ctx.fill();
                    ctx.fillStyle = '#ffd700';
                    for (let i = -2; i <= 2; i++) { ctx.beginPath(); ctx.moveTo(i * 4, 22); ctx.lineTo(i * 4, 30); ctx.lineWidth = 2; ctx.strokeStyle = '#ffd700'; ctx.stroke(); }
                } else {
                    ctx.fillStyle = '#3a3a3a'; ctx.beginPath(); ctx.ellipse(0, 0, 18, 25, 0, 0, Math.PI * 2); ctx.fill();
                }
                ctx.restore();
            }
            interact(player) {
                const dx = player.x + player.width/2 - this.x;
                const dy = player.y + player.height/2 - this.y;
                return Math.sqrt(dx*dx + dy*dy) < 80;
            }
        }

        class Couplet {
            constructor(x, y, text) { this.x = x; this.y = y; this.text = text; this.fixed = false; }
            draw(ctx) {
                ctx.save(); ctx.translate(this.x - cameraX, this.y);
                ctx.fillStyle = this.fixed ? '#cc0000' : '#444';
                ctx.fillRect(-12, 0, 24, 90);
                ctx.strokeStyle = this.fixed ? '#ffd700' : '#666';
                ctx.lineWidth = 2; ctx.strokeRect(-12, 0, 24, 90);
                if (this.fixed) {
                    ctx.fillStyle = '#ffd700'; ctx.font = 'bold 18px SimHei'; ctx.textAlign = 'center';
                    for (let i = 0; i < this.text.length; i++) ctx.fillText(this.text[i], 0, 22 + i * 22);
                }
                ctx.restore();
            }
            interact(player) {
                const dx = player.x + player.width/2 - this.x;
                const dy = player.y + player.height/2 - this.y;
                return Math.sqrt(dx*dx + dy*dy) < 70;
            }
        }

        class Rift {
            constructor(x, y) { this.x = x; this.y = y; this.animationFrame = Math.random() * Math.PI * 2; }
            update() { this.animationFrame += 0.06; }
            draw(ctx) {
                ctx.save(); ctx.translate(this.x - cameraX, this.y);
                const pulse = Math.sin(this.animationFrame) * 0.4 + 0.6;
                ctx.fillStyle = 'rgba(102, 0, 102, ' + (0.4 + pulse * 0.3) + ')';
                ctx.shadowColor = '#ff00ff'; ctx.shadowBlur = 25 * pulse;
                ctx.beginPath(); ctx.ellipse(0, 0, 35 + pulse * 10, 22 + pulse * 6, 0, 0, Math.PI * 2); ctx.fill();
                ctx.restore();
            }
            checkCollision(player) {
                const px = player.x + player.width / 2;
                const py = player.y + player.height / 2;
                const dist = Math.sqrt(Math.pow(px - this.x, 2) + Math.pow(py - this.y, 2));
                return dist < 45;
            }
        }

        class Portal {
            constructor(x, y) { this.x = x; this.y = y; this.active = false; this.particles = []; this.animationFrame = 0; }
            update() {
                if (this.active) {
                    this.animationFrame += 0.04;
                    if (Math.random() < 0.3) this.particles.push({ x: this.x + (Math.random() - 0.5) * 60, y: this.y + 60, vy: -2 - Math.random() * 2, life: 1, size: 2 + Math.random() * 3 });
                    this.particles = this.particles.filter(p => { p.y += p.vy; p.life -= 0.02; return p.life > 0; });
                }
            }
            draw(ctx) {
                if (!this.active) return;
                ctx.save(); ctx.translate(this.x - cameraX, this.y);
                const pulse = Math.sin(this.animationFrame) * 0.25 + 0.75;
                ctx.shadowColor = '#ffd700'; ctx.shadowBlur = 30 * pulse;
                ctx.fillStyle = '#ffd700';
                ctx.beginPath(); ctx.moveTo(0, -65); ctx.bezierCurveTo(-45, -50, -50, 50, 0, 65); ctx.bezierCurveTo(50, 50, 45, -50, 0, -65); ctx.fill();
                ctx.fillStyle = '#fff'; ctx.font = 'bold 18px SimHei'; ctx.textAlign = 'center'; ctx.fillText('传送', 0, 8);
                this.particles.forEach(p => { ctx.fillStyle = 'rgba(255, 215, 0, ' + p.life + ')'; ctx.beginPath(); ctx.arc(p.x - this.x, p.y - this.y, p.size, 0, Math.PI * 2); ctx.fill(); });
                ctx.restore();
            }
            checkCollision(player) {
                if (!this.active) return false;
                return player.x + player.width/2 > this.x - 40 && player.x + player.width/2 < this.x + 40 &&
                       player.y + player.height/2 > this.y - 60 && player.y + player.height/2 < this.y + 60;
            }
        }

        class Item {
            constructor(x, y, type) { this.x = x; this.y = y; this.type = type; this.collected = false; this.bobOffset = Math.random() * Math.PI * 2; }
            update() { this.bobOffset += 0.05; }
            draw(ctx) {
                if (this.collected) return;
                ctx.save(); ctx.translate(this.x - cameraX, this.y + Math.sin(this.bobOffset) * 6);
                const icons = { firecracker: '🧨', amulet: '🛡️', lu: '⚔️', shou: '❤️' };
                ctx.font = '32px Arial'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillText(icons[this.type], 0, 0);
                ctx.restore();
            }
            checkCollision(player) {
                if (this.collected) return false;
                return player.x < this.x + 35 && player.x + player.width > this.x && player.y < this.y + 35 && player.y + player.height > this.y;
            }
        }

        class NPC {
            constructor(x, y, name, dialogs, type = 'elder') { this.x = x; this.y = y; this.name = name; this.dialogs = dialogs; this.type = type; this.currentDialog = 0; }
            draw(ctx) {
                ctx.save(); ctx.translate(this.x - cameraX, this.y);
                if (this.type === 'elder') {
                    ctx.fillStyle = '#3a2a4a'; ctx.beginPath(); ctx.roundRect(-22, -35, 44, 65, 10); ctx.fill();
                    ctx.fillStyle = '#e8c8a8'; ctx.beginPath(); ctx.arc(0, -50, 18, 0, Math.PI * 2); ctx.fill();
                    ctx.fillStyle = '#2a1a3a'; ctx.beginPath(); ctx.moveTo(-15, -58); ctx.lineTo(15, -58); ctx.lineTo(0, -72); ctx.closePath(); ctx.fill();
                } else if (this.type === 'lion_dancer') {
                    ctx.fillStyle = '#ffcc00'; ctx.beginPath(); ctx.roundRect(-22, -35, 44, 65, 10); ctx.fill();
                    ctx.fillStyle = '#cc0000'; ctx.fillRect(-22, -15, 44, 6); ctx.fillRect(-22, 5, 44, 6);
                    ctx.fillStyle = '#cc0000'; ctx.beginPath(); ctx.ellipse(0, -70, 22, 18, 0, 0, Math.PI * 2); ctx.fill();
                    ctx.fillStyle = '#ffd700'; ctx.beginPath(); ctx.arc(0, -70, 8, 0, Math.PI * 2); ctx.fill();
                }
                ctx.fillStyle = '#333'; ctx.beginPath(); ctx.arc(-5, -52, 2.5, 0, Math.PI * 2); ctx.arc(5, -52, 2.5, 0, Math.PI * 2); ctx.fill();
                ctx.restore();
            }
            interact(player) {
                const dx = player.x + player.width/2 - this.x;
                const dy = player.y + player.height/2 - this.y;
                return Math.sqrt(dx*dx + dy*dy) < 90;
            }
            getDialog() {
                if (this.currentDialog >= this.dialogs.length) { this.currentDialog = 0; return null; }
                return this.dialogs[this.currentDialog++];
            }
        }

        class Phantom {
            constructor(x, y) { this.x = x; this.y = y; this.active = true; this.moveOffset = Math.random() * Math.PI * 2; }
            update() { if (this.active) { this.moveOffset += 0.01; this.x += Math.sin(this.moveOffset) * 0.5; } }
            draw(ctx) {
                if (!this.active) return;
                ctx.save(); ctx.translate(this.x - cameraX, this.y);
                ctx.globalAlpha = 0.4;
                ctx.fillStyle = '#8888aa'; ctx.beginPath(); ctx.roundRect(-19, -29, 38, 58, 10); ctx.fill();
                ctx.restore();
            }
            checkFirecracker(x, y) { return Math.sqrt(Math.pow(this.x - x, 2) + Math.pow(this.y - y, 2)) < 120; }
        }

        class ShadowPlay {
            constructor(x, y) { this.x = x; this.y = y; }
            draw(ctx) {
                ctx.save(); ctx.translate(this.x - cameraX, this.y);
                ctx.fillStyle = '#8B4513'; ctx.fillRect(-60, -60, 120, 10); ctx.fillRect(-60, -60, 10, 100); ctx.fillRect(50, -60, 10, 100);
                ctx.fillStyle = '#aa0000'; ctx.fillRect(-50, -50, 100, 90);
                ctx.fillStyle = '#ffd700'; ctx.fillRect(-50, -50, 100, 5); ctx.fillRect(-50, 35, 100, 5);
                ctx.restore();
            }
            interact(player) {
                const dx = player.x + player.width/2 - this.x;
                const dy = player.y + player.height/2 - this.y;
                return Math.sqrt(dx*dx + dy*dy) < 100;
            }
        }

        class LanternMaze {
            constructor(x, y) { this.x = x; this.y = y; this.fogLevel = 1; this.lamps = []; for (let i = 0; i < 18; i++) this.lamps.push({ angle: i / 18 * Math.PI * 2, lit: false }); }
            update() { if (this.fogLevel > 0) this.fogLevel -= 0.0003; this.lamps.forEach(l => l.lit = this.fogLevel < 0.5); }
            draw(ctx) {
                ctx.save(); ctx.translate(this.x - cameraX, this.y);
                if (this.fogLevel > 0) { ctx.fillStyle = 'rgba(80, 80, 90, ' + (this.fogLevel * 0.5) + ')'; ctx.beginPath(); ctx.ellipse(0, 0, 120, 60, 0, 0, Math.PI * 2); ctx.fill(); }
                ctx.strokeStyle = '#ffd700'; ctx.lineWidth = 3; ctx.beginPath(); ctx.ellipse(0, 0, 120, 60, 0, 0, Math.PI * 2); ctx.stroke();
                this.lamps.forEach(l => {
                    ctx.save(); ctx.translate(Math.cos(l.angle) * 120, Math.sin(l.angle) * 60);
                    ctx.fillStyle = l.lit ? '#ff6600' : '#444'; ctx.beginPath(); ctx.ellipse(0, 0, 10, 14, 0, 0, Math.PI * 2); ctx.fill();
                    ctx.restore();
                });
                ctx.restore();
            }
        }

        class Particle {
            constructor(x, y, color) { this.x = x; this.y = y; this.color = color; this.size = Math.random() * 6 + 2; this.speedX = (Math.random() - 0.5) * 8; this.speedY = (Math.random() - 0.5) * 8 - 2; this.life = 1; }
            update() { this.x += this.speedX; this.y += this.speedY; this.speedY += 0.05; this.life -= 0.02; this.size *= 0.96; }
            draw(ctx) { ctx.save(); ctx.globalAlpha = this.life; ctx.fillStyle = this.color; ctx.beginPath(); ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2); ctx.fill(); ctx.restore(); }
        }

        class Firework {
            constructor(x, y) { this.x = x; this.y = y; this.particles = []; for (let i = 0; i < 30; i++) this.particles.push({ x, y, vx: Math.cos(i/30*Math.PI*2)*(3+Math.random()*3), vy: Math.sin(i/30*Math.PI*2)*(3+Math.random()*3), life: 1 }); }
            update() { this.particles.forEach(p => { p.x += p.vx; p.y += p.vy; p.vy += 0.08; p.life -= 0.02; }); }
            draw(ctx) { this.particles.forEach(p => { if (p.life > 0) { ctx.save(); ctx.globalAlpha = p.life; ctx.fillStyle = '#ffd700'; ctx.beginPath(); ctx.arc(p.x, p.y, 2, 0, Math.PI * 2); ctx.fill(); ctx.restore(); } }); }
            isDead() { return this.particles.every(p => p.life <= 0); }
        }

        function createParticles(x, y, color, count) { for (let i = 0; i < count; i++) particles.push(new Particle(x, y, color)); }
        function createFirework(x, y) { fireworks.push(new Firework(x, y)); }

        const audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        function playSound(type) {
            const osc = audioCtx.createOscillator();
            const gain = audioCtx.createGain();
            osc.connect(gain); gain.connect(audioCtx.destination);
            if (type === 'jump') { osc.frequency.setValueAtTime(300, audioCtx.currentTime); osc.frequency.exponentialRampToValueAtTime(600, audioCtx.currentTime + 0.1); gain.gain.setValueAtTime(0.1, audioCtx.currentTime); gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.15); }
            else if (type === 'collect') { osc.frequency.setValueAtTime(523, audioCtx.currentTime); osc.frequency.setValueAtTime(659, audioCtx.currentTime + 0.1); osc.frequency.setValueAtTime(784, audioCtx.currentTime + 0.2); gain.gain.setValueAtTime(0.1, audioCtx.currentTime); gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.3); }
            else if (type === 'purify') { osc.frequency.setValueAtTime(440, audioCtx.currentTime); osc.frequency.setValueAtTime(880, audioCtx.currentTime + 0.3); gain.gain.setValueAtTime(0.15, audioCtx.currentTime); gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.4); }
            else if (type === 'damage') { osc.type = 'sawtooth'; osc.frequency.setValueAtTime(100, audioCtx.currentTime); osc.frequency.exponentialRampToValueAtTime(50, audioCtx.currentTime + 0.3); gain.gain.setValueAtTime(0.15, audioCtx.currentTime); gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.3); }
            else if (type === 'firecracker') { osc.type = 'square'; osc.frequency.setValueAtTime(800, audioCtx.currentTime); osc.frequency.exponentialRampToValueAtTime(400, audioCtx.currentTime + 0.15); gain.gain.setValueAtTime(0.2, audioCtx.currentTime); gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.2); }
            else if (type === 'portal') { osc.type = 'sine'; osc.frequency.setValueAtTime(150, audioCtx.currentTime); osc.frequency.setValueAtTime(300, audioCtx.currentTime + 0.5); osc.frequency.setValueAtTime(600, audioCtx.currentTime + 1); gain.gain.setValueAtTime(0.1, audioCtx.currentTime); gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 1.5); }
            osc.start(); osc.stop(audioCtx.currentTime + 1.5);
        }

        function updateUI() {
            document.getElementById('healthFill').style.width = health + '%';
            document.getElementById('progressFill').style.width = progress + '%';
            document.getElementById('progressText').textContent = Math.round(progress) + '%';
            document.getElementById('countFirecracker').textContent = globalInventory.firecracker;
            document.getElementById('countAmulet').textContent = globalInventory.amulet;
            document.getElementById('countLu').textContent = globalInventory.lu;
            document.getElementById('countShou').textContent = globalInventory.shou;
            if (collectedFragments.fu) document.getElementById('fragmentFu').classList.add('collected');
            if (collectedFragments.lu) document.getElementById('fragmentLu').classList.add('collected');
            if (collectedFragments.shou) document.getElementById('fragmentShou').classList.add('collected');
        }

        function showDialog(name, content) {
            document.getElementById('dialogName').textContent = name;
            document.getElementById('dialogContent').textContent = content;
            document.getElementById('dialogBox').style.display = 'block';
            setTimeout(() => { document.getElementById('dialogBox').style.display = 'none'; }, 4000);
        }

        function showLevelHint(text) {
            document.getElementById('levelHint').textContent = text;
            document.getElementById('levelHint').style.display = 'block';
            setTimeout(() => { document.getElementById('levelHint').style.display = 'none'; }, 4000);
        }

        function showFragmentNotification() {
            document.getElementById('fragmentNotification').style.display = 'block';
            setTimeout(() => { document.getElementById('fragmentNotification').style.display = 'none'; }, 1500);
        }

        function initLevel1() {
            entities = [];
            player = new Player(150, canvas.height - 150);
            portal = new Portal(2800, canvas.height - 160);
            
            entities.push(new Lantern(300, 200), new Lantern(500, 220), new Lantern(700, 180),
                          new Lantern(900, 210), new Lantern(1100, 190), new Lantern(1300, 220));
            entities.push(new Couplet(250, 280, ['春', '风', '送', '暖']), new Couplet(350, 280, ['福', '气', '满', '门']),
                          new Couplet(850, 270, ['喜', '迎', '新', '春']), new Couplet(950, 270, ['吉', '祥', '如', '意']),
                          new Couplet(1250, 280, ['万', '事', '如', '意']), new Couplet(1350, 280, ['五', '福', '临', '门']));
            entities.push(new Rift(450, canvas.height - 80), new Rift(800, canvas.height - 80),
                          new Rift(1150, canvas.height - 80), new Rift(1500, canvas.height - 80),
                          new Rift(1850, canvas.height - 80), new Rift(2200, canvas.height - 80));
            entities.push(new Item(400, canvas.height - 120, 'firecracker'), new Item(850, canvas.height - 120, 'firecracker'),
                          new Item(1200, canvas.height - 120, 'amulet'), new Item(1600, canvas.height - 120, 'firecracker'),
                          new Item(2000, canvas.height - 120, 'amulet'));
            entities.push(new NPC(600, canvas.height - 140, '老爷爷', ['孩子啊，这古镇被浊气笼罩，快点亮灯笼、修复春联净化这里吧！', '小心脚下的裂隙，那是魔气侵蚀的痕迹！', '净化完成后，东方会出现传送门，你可以前往庙会。'], 'elder'));
            
            fogOpacity = 0.7;
            progress = 0;
        }

        function initLevel2() {
            entities = [];
            player = new Player(150, canvas.height - 150);
            
            entities.push(new Phantom(500, canvas.height - 140), new Phantom(800, canvas.height - 140),
                          new Phantom(1100, canvas.height - 140), new Phantom(1400, canvas.height - 140),
                          new Phantom(1700, canvas.height - 140));
            entities.push(new ShadowPlay(900, canvas.height - 160));
            entities.push(new LanternMaze(1800, canvas.height - 130));
            entities.push(new Item(2200, canvas.height - 130, 'shou'));
            entities.push(new Item(550, canvas.height - 120, 'firecracker'), new Item(1200, canvas.height - 120, 'firecracker'),
                          new Item(1600, canvas.height - 120, 'firecracker'));
            
            lionDancer = new NPC(1800, canvas.height - 140, '舞狮少年', ['跟着我，我来帮你驱散迷雾！', '九曲灯阵的迷雾怕光，我们一起点亮它！'], 'lion_dancer');
            entities.push(lionDancer);
            
            remainingPhantoms = 5;
            fogOpacity = 0.5;
            window.level2Completed = false;
        }

        function drawBackground() {
            const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
            if (currentLevel === 1) {
                const grayness = Math.max(0, 1 - progress / 100);
                const r = Math.floor(30 * (1 - grayness) + 80 * grayness);
                const g = Math.floor(20 * (1 - grayness) + 75 * grayness);
                const b = Math.floor(25 * (1 - grayness) + 70 * grayness);
                gradient.addColorStop(0, 'rgb(' + r + ', ' + g + ', ' + b + ')');
                gradient.addColorStop(1, 'rgb(' + (r - 20) + ', ' + (g - 20) + ', ' + (b - 20) + ')');
            } else {
                gradient.addColorStop(0, '#2a1a2a');
                gradient.addColorStop(1, '#1a0a1a');
            }
            ctx.fillStyle = gradient;
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            if (currentLevel === 1) {
                ctx.fillStyle = 'rgba(50, 50, 60, ' + (fogOpacity * 0.4) + ')';
                for (let i = 0; i < 15; i++) {
                    const x = (i * 250 + Date.now() * 0.02) % (3200 + canvas.width);
                    ctx.fillRect(x - cameraX, 100 + Math.sin(i) * 50, 150, 80);
                }
            }
            
            ctx.fillStyle = '#2a1a0a';
            ctx.fillRect(0, canvas.height - 80, 3200, 80);
            ctx.fillStyle = '#4a3a2a';
            ctx.fillRect(0, canvas.height - 85, 3200, 5);
            
            if (currentLevel === 1) {
                ctx.fillStyle = '#3a2a1a';
                for (let i = 0; i < 10; i++) {
                    ctx.fillRect(i * 320 + 50, canvas.height - 75, 200, 3);
                }
            } else {
                ctx.fillStyle = '#cc6600';
                for (let i = 0; i < 10; i++) {
                    ctx.fillRect(i * 320 + 50, canvas.height - 75, 200, 3);
                }
            }
        }

        function draw() {
            drawBackground();
            
            if (currentLevel === 1 && portal) portal.draw(ctx);
            
            entities.forEach(e => e.draw(ctx));
            player.draw(ctx);
            
            particles.forEach(p => p.draw(ctx));
            fireworks.forEach(f => f.draw(ctx));
            
            if (currentLevel === 2) {
                ctx.fillStyle = '#ffd700';
                ctx.font = 'bold 18px SimHei';
                ctx.textAlign = 'left';
                ctx.fillText('剩余幻象: ' + remainingPhantoms, 25, 680);
            }
            
            ctx.fillStyle = 'rgba(255,255,255,0.7)';
            ctx.font = '14px SimHei';
            ctx.textAlign = 'center';
            ctx.fillText('操作：A/D移动 | 空格跳跃 | 鼠标点击交互 | 数字键1使用鞭炮 | R重置', canvas.width / 2, canvas.height - 10);
        }

        function update() {
            if (gameState !== 'playing') return;
            
            player.update();
            
            entities.forEach(e => {
                if (e.update) e.update();
                if (e.checkCollision && e.checkCollision(player)) {
                    if (e instanceof Rift) {
                        riftDamageTimer++;
                        if (riftDamageTimer > 30) {
                            health -= 5;
                            riftDamageTimer = 0;
                            playSound('damage');
                            createParticles(player.x + player.width/2, player.y + player.height/2, '#ff0000', 10);
                        }
                    } else if (e.checkCollision(player)) {
                        e.collected = true;
                        if (e.type === 'firecracker') { globalInventory.firecracker++; playSound('collect'); }
                        else if (e.type === 'amulet') { globalInventory.amulet++; health = Math.min(100, health + 20); playSound('collect'); }
                        else if (e.type === 'lu') { globalInventory.lu++; collectedFragments.lu = true; showFragmentNotification(); playSound('collect'); }
                        else if (e.type === 'shou') { globalInventory.shou++; collectedFragments.shou = true; showFragmentNotification(); playSound('collect'); }
                    }
                }
            });
            
            if (currentLevel === 1 && portal && portal.checkCollision(player)) {
                document.getElementById('levelCompleteTitle').textContent = '古镇净化完成！';
                document.getElementById('levelCompleteSub').textContent = '恭喜你获得福碎片！即将前往新春庙会';
                document.getElementById('levelComplete').style.display = 'flex';
                collectedFragments.fu = true;
                globalInventory.lu++;
            }
            
            if (lionDancer) {
                const dx = player.x - lionDancer.x;
                if (Math.abs(dx) > 150) {
                    lionDancer.x += dx > 0 ? 2 : -2;
                }
            }
            
            particles = particles.filter(p => { p.update(); return p.life > 0; });
            fireworks = fireworks.filter(f => { f.update(); return !f.isDead(); });
            
            if (currentLevel === 1) {
                const litLanterns = entities.filter(e => e instanceof Lantern && e.lit).length;
                const fixedCouplets = entities.filter(e => e instanceof Couplet && e.fixed).length;
                const total = 12;
                const completed = litLanterns + fixedCouplets;
                progress = (completed / total) * 100;
                
                if (completed === total && portal && !portal.active) {
                    portal.active = true;
                    playSound('portal');
                    showLevelHint('传送门已开启！点击前往庙会');
                }
            }
            
            if (currentLevel === 2) {
                const phantoms = entities.filter(e => e instanceof Phantom && e.active);
                remainingPhantoms = phantoms.length;
                
                if (collectedFragments.lu && collectedFragments.shou && !window.level2Completed) {
                    window.level2Completed = true;
                    setTimeout(() => {
                        document.getElementById('levelCompleteTitle').textContent = '新春庙会完成！';
                        document.getElementById('levelCompleteSub').textContent = '恭喜你集齐福禄寿三碎片，新春大吉！';
                        document.getElementById('levelComplete').style.display = 'flex';
                    }, 1000);
                }
            }
            
            if (health <= 0) {
                document.getElementById('gameOver').style.display = 'flex';
                gameState = 'gameover';
            }
            
            updateUI();
        }

        function gameLoop() {
            update();
            draw();
            requestAnimationFrame(gameLoop);
        }

        canvas.addEventListener('click', (e) => {
            if (gameState !== 'playing') return;
            
            const rect = canvas.getBoundingClientRect();
            const clickX = (e.clientX - rect.left) + cameraX;
            const clickY = e.clientY - rect.top;
            
            entities.forEach(e => {
                if (e instanceof Lantern && !e.lit && e.interact(player)) {
