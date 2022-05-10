<template>
  <b-container>
    <b-col align-self="center">
      <b-row>
        <b-input-group size="sm" class="mb-2">
          <b-input-group-prepend is-text>
            <b-icon icon="cursor"></b-icon>
            检索场景
          </b-input-group-prepend>
          <b-form-input v-model="sentence" placeholder="请输入你想搜索的场景"></b-form-input>
        </b-input-group>
      </b-row>
      <br>
      <!--      <b-row>-->
      <!--        <b-input-group size="sm" class="mb-2">-->
      <!--          <b-input-group-prepend is-text>-->
      <!--            <b-icon icon="diamond"></b-icon>-->
      <!--            字幕/旁白-->
      <!--          </b-input-group-prepend>-->
      <!--          <b-form-input v-model="drama" placeholder="请输入你想展示的字幕"></b-form-input>-->
      <!--        </b-input-group>-->
      <!--      </b-row>-->
      <!--      <br>-->
      <br>
    </b-col>

    <b-col>
      <b-row>
        <b-button pill variant="primary" v-on:click="getSearchData()">点击搜索
          <b-icon icon="search"></b-icon>
        </b-button>
      </b-row>
    </b-col>
    <br>

    <b-col align-self="end">
      <b-row>
        <b-button pill variant="secondary" v-on:click="nextVideo()">下一幕
          <b-icon icon="arrow-right"></b-icon>
        </b-button>
      </b-row>
      <br>
      <b-row>
        <b-button pill variant="success" v-on:click="mergeVideo()">最终提交
          <b-icon icon="check"></b-icon>
        </b-button>
      </b-row>
    </b-col>


    <b-list-group horizontal="md">
      <b-list-group-item v-for="(value, index) in preview_urls" :key="index" button :active="activeClass == index">
        video{{ index }}
        <b-img :src="value" fluid alt="Fluid image" v-on:click="selectVideo(index)"></b-img>

        <!--        <b-row>-->
        <br>
        <b-input-group size="sm" class="mb-2" v-show="activeClass == index">
          <b-input-group-prepend is-text>
            <b-icon icon="diamond"></b-icon>
            字幕/旁白
          </b-input-group-prepend>
          <b-col>

            <b-form-input v-model="drama1" placeholder="请输入你想展示的第一句字幕"></b-form-input>
            <b-form-input v-model="drama2" placeholder="第二句"></b-form-input>
            <b-form-input v-model="drama3" placeholder="第三句"></b-form-input>

          </b-col>
        </b-input-group>
        <!--        </b-row>-->
        <!--        <br>-->

      </b-list-group-item>
    </b-list-group>

    <br>


    <a :href="resVideo">{{resVideo}}</a>
    <div class="circles-video" v-if="showVideo">
<!--      <span v-html="videoSource"></span>-->
      <!--      <video id="video" :src=resVideo controls autoplay width="300" height="300" :style="[dispalyVideo]">-->
      <video id="video"
             :src=resVideo
             controls autoplay width="300" height="300">
      </video>
    </div>

  </b-container>
</template>

<script>
import axios from "axios";

export default {
  name: 'Main',
  data: function () {
    return {
      drama1: "学校上课的日子有点无聊",
      drama2: "",
      drama3: "",
      words: [],
      sentence: '一群学生在上课',
      collection_id: "panda_metaverse_video",
      collection_ids: ["panda_metaverse_video", "shuyi_test_panda_crawl_0", "coper_demo"],
      metavideos: [],
      video_urls: [],
      preview_urls: [],
      start_time: [],
      urlSelected: null,
      startTimeSelected: null,
      activeClass: -1,
      pendingVideo: [],
      resVideo: null,
      showVideo: false,
      // dispalyVideo: {opacity: '0'},
    };
  },
  // watch: {
  //   currentSrc() {
  //     this.$nextTick(() => {
  //       this.showVideo = true
  //     })
  //   },
  // },
    // watch: {
  //   resVideo(newV, oldV){
  //     console.log("123321", newV, oldV)
  //     // console.log(this.resVideo)
  //     this.resVideo = newV
  //     // console.log('data change to %d', newV);
  //   }
  // },
  // computed: {
  //   // 计算属性的 getter
  //   videoSource: function () {
  //     return `<video controls autoplay width="360" height="640"><source src="${this.resVideo}" type="video/mp4"></video>`;
  //   }
  // },
  methods: {
    getVideoData(video_id) {
      var video = document.getElementById("video" + video_id);
      video.src = this.video_urls[video_id]
      video.play()
      video.startTime = this.start_time[video_id]
      video.ondurationchange = function () {
        console.log("currentTime:", video.currentTime)
      }
      video.addEventListener('pause', function (e) {
        console.log('暂停播放')
        console.log(e)
        console.log("暂停时间:", video.currentTime)
      })
    },
    mergedramas() {
      this.words.push(this.drama1)
      this.words.push(this.drama2)
      this.words.push(this.drama3)
    },
    mergeVideo() {
      this.addSelectedVideo()
      console.log(this.pendingVideo)
      this.clearData()
      this.processVideo()
      this.showVideo = true
      // this.dispalyVideo.opacity = '1'
    },
    addSelectedVideo() {
      this.mergedramas()
      let singleVideoInfo = {
        "video_url": this.urlSelected,
        "start_time": this.startTimeSelected,
        "words": this.words,
      }
      this.pendingVideo.push(singleVideoInfo)
    },
    selectVideo(index) {
      this.activeClass = index
      this.urlSelected = this.metavideos[index]
      this.startTimeSelected = this.start_time[index]
      console.log(this.urlSelected, this.startTimeSelected)
    },
    nextVideo() {
      this.addSelectedVideo()
      this.clearData()
    },
    clearData() {
      this.urlSelected = ''
      this.startTimeSelected = ''
      this.sentence = ''
      this.activeClass = -1
      this.words = []
      this.drama1 = ''
      this.drama2 = ''
      this.drama3 = ''
      this.metavideos = []
      this.video_urls = []
      this.preview_urls = []
      this.start_time = []
    },
    getSearchData() {
      let num_output = 10;
      this.PopToast("b-toaster-top-center", num_output + "提交成功, 正在检索");
      let metavideo = []
      let videos = []
      let previews = []
      let start = []
      const url = "http://power.mirav.cn:3010/afu_fs_search"
      let requests_data = {
        "query_object": this.sentence,
        "user_id": this.collection_id,
        "num_output": num_output,
        "raw": true,
      }
      console.log(this.sentence, this.collection_id, url);
      axios.post(url, requests_data, {headers: {'Content-Type': 'application/json'}})
          .then(response => {
            let all_data = response.data.result
            for (var i = 0; i < num_output; i++) {
              let start_time = all_data[i][1]
              let response_url = all_data[i][3][0]
              start.push(start_time)
              metavideo.push(response_url)
              videos.push(response_url + "#t=" + start_time)
              previews.push(response_url + "?ci-process=snapshot&time=" + start_time + "&format=jpg")
            }
            // console.log(videos)
            // console.log(previews)
            this.metavideos = metavideo
            this.preview_urls = previews
            this.video_urls = videos
            this.start_time = start
          })
          .catch(function (error) {
            console.log(error);
          })
    },
    PopToast(toaster, message, append = false) {
      this.$bvToast.toast(message, {
        autoHideDelay: 5000, //自动消失时间，毫秒为单位
        title: `Toaster`,
        toaster: toaster,
        solid: true,
        appendToast: append
      })
    },
    processVideo() {
      const url = "http://power.mirav.cn:3030/ttv"
      // const url = "http://localhost:5000/ttv"
      let data = JSON.stringify(this.pendingVideo).toString();
      let str_data = '{"video": ' + data + '}'
      let requests_data = JSON.parse(str_data)
      axios.post(url, requests_data, {headers: {'Content-Type': 'application/json'}})
          .then(response => {
            this.resVideo = response.data
            console.log("res:", this.resVideo)
          })
          .catch(function (error) {
            console.log(error);
          })

    },
  },
}
</script>

