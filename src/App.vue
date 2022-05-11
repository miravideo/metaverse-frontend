<template>
  <div id="app">
    <h3>说明文档在这里:<a href="https://meowing-staircase-143.notion.site/v0-1-0-a135cc8e8e6046ef9e849a55d0ebaff7">Doc</a></h3>
    <hr>
    <img alt="Vue logo" src="./assets/demo.png">
    <Main/>
  </div>
</template>

<script>
import Main from './components/Main.vue'

export default {
  name: 'App',
  components: {
    Main
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
