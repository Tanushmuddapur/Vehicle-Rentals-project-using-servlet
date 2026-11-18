<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String context = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#070707">
<title>ARK — Arrive in Style</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
:root{--black:#070707;--gold:#d6ad64;--pale:#f0d49a;--white:#f7f4ed;--muted:#c0bbb1;--serif:"Cormorant Garamond",Georgia,serif;--sans:"Inter",Arial,sans-serif}
*{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{background:var(--black);color:var(--white);font-family:var(--sans);overflow:hidden}
a{color:inherit;text-decoration:none}
.welcome{position:relative;isolation:isolate;min-height:100svh;display:flex;align-items:center;overflow:hidden;background:#070707}
.car-image{position:absolute;z-index:-3;inset:0;background-image:url("https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=2400&q=92");background-size:cover;background-position:center 58%;filter:brightness(.76) saturate(.72);transform:scale(1.12);animation:carReveal 2.2s cubic-bezier(.2,.7,.2,1) forwards}
.welcome:before{content:"";position:absolute;z-index:-2;inset:0;background:linear-gradient(90deg,rgba(5,5,5,.97) 0%,rgba(5,5,5,.83) 30%,rgba(5,5,5,.3) 68%,rgba(5,5,5,.12) 100%),linear-gradient(0deg,#070707 0%,transparent 35%,rgba(0,0,0,.25) 100%)}
.welcome:after{content:"";position:absolute;z-index:-1;inset:16px;border:1px solid rgba(214,173,100,.2);pointer-events:none}
.topbar{position:absolute;left:0;top:0;width:100%;padding:31px 7%;display:flex;justify-content:space-between;align-items:center;animation:fadeDown 1s .2s both}
.logo{font-family:var(--serif);font-size:29px;letter-spacing:8px;color:var(--pale);font-weight:600;line-height:1}
.logo small{display:block;font:500 8px var(--sans);letter-spacing:3px;margin-top:8px;color:#d8c39d}
.top-label{font-size:9px;letter-spacing:3px;text-transform:uppercase;color:#ddd5c6}
.content{width:min(760px,82%);margin-left:10%;padding:120px 0 105px;animation:contentIn 1.15s .35s both}
.kicker{display:flex;align-items:center;gap:14px;color:var(--pale);font-size:9px;font-weight:600;letter-spacing:4px;text-transform:uppercase}
.kicker:before{content:"";height:1px;width:42px;background:var(--gold)}
h1{margin-top:26px;font:300 clamp(72px,10vw,142px)/.78 var(--serif);letter-spacing:-3px}
h1 span{display:block;color:var(--pale);font-style:italic;margin:17px 0 0 9%}
.description{max-width:390px;margin-top:33px;color:#d0cbc1;font-size:11px;line-height:2.1;font-weight:300}
.actions{display:flex;align-items:center;gap:14px;flex-wrap:wrap;margin-top:32px}
.btn{min-height:51px;padding:0 23px;display:inline-flex;align-items:center;justify-content:center;gap:25px;border:1px solid var(--gold);font-size:9px;font-weight:600;letter-spacing:1.7px;transition:all .3s}
.btn-primary{background:var(--gold);color:#100e09}
.btn-primary:hover{background:var(--pale);transform:translateY(-3px);box-shadow:0 10px 32px #d6ad6425}
.btn-ghost{border-color:#ffffff66;background:#ffffff05}
.btn-ghost:hover{border-color:var(--gold);color:var(--pale);transform:translateY(-3px)}
.btn span{font-size:17px;transition:transform .3s}
.btn:hover span{transform:translateX(4px)}
.side-index{position:absolute;right:7%;bottom:95px;display:flex;align-items:center;gap:12px;writing-mode:vertical-rl;color:#ffffffb3;font-size:8px;letter-spacing:3px;animation:fadeUp 1s 1s both}
.side-index:before{content:"";height:42px;width:1px;background:var(--gold)}
.bottom-line{position:absolute;bottom:34px;left:7%;right:7%;display:flex;justify-content:space-between;align-items:center;border-top:1px solid #d6ad6430;padding-top:17px;color:#aaa398;font-size:8px;letter-spacing:2px;text-transform:uppercase;animation:fadeUp 1s 1s both}
.bottom-line strong{color:var(--pale);font-weight:500}
@keyframes carReveal{to{transform:scale(1.02)}}
@keyframes contentIn{from{opacity:0;transform:translateY(30px);filter:blur(4px)}to{opacity:1;transform:translateY(0);filter:blur(0)}}
@keyframes fadeDown{from{opacity:0;transform:translateY(-14px)}to{opacity:1;transform:translateY(0)}}
@keyframes fadeUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
@media(max-width:650px){
 body{overflow:auto}.welcome{min-height:100svh}.car-image{background-position:61% center}
 .welcome:before{background:linear-gradient(90deg,#050505e8,#05050555),linear-gradient(0deg,#070707 0%,#07070755 72%,#070707a0)}
 .welcome:after{inset:9px}.topbar{padding:25px 8%}.logo{font-size:26px;letter-spacing:6px}.top-label{max-width:110px;text-align:right;font-size:7px;line-height:1.8}
 .content{width:84%;margin:0 8%;padding:125px 0 115px}.kicker{font-size:8px;letter-spacing:2.5px}
 h1{font-size:clamp(68px,16vw,96px)}h1 span{margin-left:5%}.description{font-size:11px;max-width:330px}
 .actions{align-items:stretch;flex-direction:column;max-width:280px}.btn{justify-content:space-between}
 .side-index{display:none}.bottom-line{left:8%;right:8%;bottom:25px;font-size:7px;letter-spacing:1px;gap:12px}
}
@media(prefers-reduced-motion:reduce){*,*:before,*:after{animation-duration:.01ms!important;transition-duration:.01ms!important}}
</style>
</head>
<body>
<main class="welcome">
  <div class="car-image" aria-hidden="true"></div>
  <header class="topbar">
    <a class="logo" href="<%= context %>/welcome.jsp" aria-label="ARK welcome">ARK<small>VEHICLE RENTALS</small></a>
    <div class="top-label">A more refined journey</div>
  </header>
  <section class="content">
    <div class="kicker">Welcome to ARK</div>
    <h1>Arrive in<span>Style.</span></h1>
    <p class="description">The road is yours to discover. Explore a curated driving experience, find the vehicle for your next journey, and make every arrival unforgettable.</p>
    <div class="actions">
      <a class="btn btn-primary" href="<%= context %>/index.jsp">ENTER ARK <span aria-hidden="true">↗</span></a>
      <a class="btn btn-ghost" href="<%= context %>/login.jsp">SIGN IN <span aria-hidden="true">→</span></a>
    </div>
  </section>
  <div class="side-index">THE ARK EXPERIENCE &nbsp; / &nbsp; 01</div>
  <footer class="bottom-line"><span>Precision in every detail</span><strong>Drive with distinction</strong></footer>
</main>
</body>
</html>
