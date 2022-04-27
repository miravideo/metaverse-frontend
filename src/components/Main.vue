<template>
  <b-container>
    <b-col align-self="center">
      <b-row>
        <b-input-group size="sm" class="mb-2">
          <b-input-group-prepend is-text>
            <b-icon icon="cursor"></b-icon>
          </b-input-group-prepend>
          <b-form-input v-model="sentence" placeholder="请输入你想搜索的场景"></b-form-input>
        </b-input-group>
      </b-row>
      <br>
      <b-row>
        <b-input-group size="sm" class="mb-2">
          <b-input-group-prepend is-text>
            <b-icon icon="diamond"></b-icon>
          </b-input-group-prepend>
          <b-form-input v-model="drama" placeholder="请输入你想展示的字幕"></b-form-input>
        </b-input-group>
      </b-row>
      <br>
      <b-row>
        <b-input-group size="sm" class="mb-2">
          <b-input-group-prepend is-text>
            <b-icon icon="command"></b-icon>
          </b-input-group-prepend>
          <b-form-select v-model="collection_id" :options="collection_ids" size="lg"></b-form-select>
        </b-input-group>
      </b-row>
      <br>
    </b-col>

    <b-col align-self="end">
      <b-row>
        <b-button pill variant="success" v-on:click="clearData()">下一幕</b-button>
      </b-row>
      <br>
      <b-row>
        <b-button pill variant="success">最终提交</b-button>
      </b-row>
    </b-col>

    <b-col>
      <b-row>
        <b-button pill variant="primary" v-on:click="getSearchData()">点击搜索
          <b-icon icon="search"></b-icon>
        </b-button>
      </b-row>
    </b-col>
    <br>
    <!--    <pre class="video_urls">{{ video_urls[1] }}</pre>-->
    <!--    <pre class="video_urls">{{ preview_urls[1] }}</pre>-->


    <b-list-group horizontal="md">
      <b-list-group-item button>video1
        <b-img :src="preview_urls[0]" fluid alt="Fluid image"></b-img>
      </b-list-group-item>
      <b-list-group-item button active>video2
        <b-img :src="preview_urls[1]" fluid alt="Fluid image"></b-img>
      </b-list-group-item>
      <b-list-group-item button>video3
        <b-img :src="preview_urls[2]" fluid alt="Fluid image"></b-img>
      </b-list-group-item>
      <b-list-group-item button>video4
        <b-img :src="preview_urls[4]" fluid alt="Fluid image"></b-img>
      </b-list-group-item>
    </b-list-group>
    <br>

    <b-list-group horizontal="md">
      <b-list-group-item button>video5
        <b-img :src="preview_urls[5]" fluid alt="Fluid image"></b-img>
      </b-list-group-item>
      <b-list-group-item button>video6
        <b-img :src="preview_urls[6]" fluid alt="Fluid image"></b-img>
      </b-list-group-item>
      <b-list-group-item button>video7
        <b-img :src="preview_urls[7]" fluid alt="Fluid image"></b-img>
      </b-list-group-item>
      <b-list-group-item button>video8
        <b-img :src="preview_urls[8]" fluid alt="Fluid image"></b-img>
      </b-list-group-item>
    </b-list-group>

  </b-container>
</template>

<script>
import axios from "axios";

export default {
  name: 'Main',
  data: function () {
    return {
      radioGroup: 1,
      drama: "学校上课的日子有点无聊",
      sentence: '一群学生在上课',
      collection_id: "panda_metaverse_video",
      collection_ids: ["panda_metaverse_video", "shuyi_test_panda_crawl_0", "coper_demo"],
      metavideos: [],
      video_urls: [],
      preview_urls: [],
      start_time: [],
      curVideo: null,
      selected: 'radio1',
      options: [

        {text: 'Radio 1', value: 'radio1'},
        {text: 'Radio 3', value: 'radio2'},
        {text: 'Radio 3 (disabled)', value: 'radio3', disabled: true},
        {text: 'Radio 4', value: 'radio4'},
        // {text: '123', value: this.preview_urls[0]}
      ],
    };
  },
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
    clearData() {
      this.drama = ''
      this.sentence = ''
      this.metavideos = []
      this.video_urls = []
      this.preview_urls = []
      this.start_time = []
    },

    getSearchData() {
      // ElMessage({
      //   message: '提交成功，正在检索',
      //   type: 'success',
      // })
      let num_output = 20;
      this.PopToast("b-toaster-top-center", num_output + "提交成功, 正在检索");
      // let num_output = 20;
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
              // let end_time = all_data[i][1] + 2
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
    getSearchData2() {
      // ElMessage({
      //   message: '提交成功，正在检索',
      //   type: 'success',
      // })
      const url = "https://mar.mirav.cn/hola/movie?sentence=" + this.sentence + "&user_id=" + this.faiss_id + "&size=20&type=faiss";
      console.log(this.sentence, this.faiss_id, url);
      axios.get(url)
          .then(response => {
            console.log(response)
            var re = new RegExp("https://mira-1255830993.cos.ap-shanghai.myqcloud.com/metaverse_video/raw/[^\\\\s]*mp4#t=[^\\\\s]*0")
            var res = response.data.match(re);
            this.url = res[0];
            console.log(this.url)
            this.video_urls = this.url

          })
          .catch(function (error) {
            console.log(error);
          })
    },
  },
}
</script>

