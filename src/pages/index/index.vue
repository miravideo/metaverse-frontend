<template>
<!--  <view>-->
<!--    <image src="../../assets/demo.png" style="-->
<!--    width:100px;-->
<!--    height:100px;"></image>-->
<!--  </view>-->
  <view>
    <AtForm>
      <AtInput
        name='value'
        title='搜索词'
        type='text'
        placeholder='一个人在吃饭'
        :value="value"
        @change="handleChange"
      />
      <AtButton formType='submit' @click="onSubmit" style="background-color: #6190E8">
        提交
      </AtButton>
      <AtButton formType='reset' @click="onReset" style="background-color: #6190E8">重置</AtButton>
    </AtForm>
  </view>

  <view>
    <at-flex wrap="wrap" justify="around">

      <image src="../../assets/demo.png" style="height: 100px; width: 100px"></image>
      <image src="../../assets/demo.png" style="height: 100px; width: 100px"></image>
      <image src="../../assets/demo.png" style="height: 100px; width: 100px"></image>
      <image src="../../assets/demo.png" style="height: 100px; width: 100px"></image>
      <image src="../../assets/demo.png" style="height: 100px; width: 100px"></image>
      <image src="../../assets/demo.png" style="height: 100px; width: 100px"></image>
      <image src="../../assets/demo.png" style="height: 100px; width: 100px"></image>
      <image src="../../assets/demo.png" style="height: 100px; width: 100px"></image>
    </at-flex>

  </view>

  <view>
    <page header-title="Radio 单选框">
      <panel
        title="基础用法"
        no-padding
      >
        <view class="radio-container">
          <at-radio
            :options="options"
            :value="selected"
            @click="handleRadioChange"
          />
        </view>
      </panel>

      <panel
        title="使用 v-model:value"
        no-padding
      >
        <view class="radio-container">
          <at-radio
            :options="options"
            v-model:value="selected"
          />
        </view>
      </panel>
    </page>
  </view>

</template>

<script>
import {ref} from 'vue'
import './index.scss'
import {AtForm, AtInput, AtButton} from 'taro-ui-vue3'
import { AtFlex, AtFlexItem } from 'taro-ui-vue3'
import { AtRadio } from 'taro-ui-vue3'
// @import "taro-ui-vue3/dist/style/components/form.scss";
// @import "taro-ui-vue3/dist/style/components/radio.scss";
export default {
  name: 'Main',
  data: function () {
    return {
      radioGroup: 1,
      drama: "学校上课的日子有点无聊",
      sentence: '一群学生在上课',
      collection_id: "panda_metaverse_video",
      metavideos: [],
      video_urls: [],
      preview_urls: [],
      start_time: [],
      selected: 'radio1',
      options: [
        {text: 'Radio 1', value: 'radio1'},
        {text: 'Radio 3', value: 'radio2'},
        {text: 'Radio 3 (disabled)', value: 'radio3', disabled: true},
        {text: 'Radio 4', value: 'radio4'},
      ],
    };
  },
  components: {
    AtForm,
    AtInput,
    AtButton,
    AtRadio,
    AtFlex,
    AtFlexItem,

  },
  methods: {
    handleChange(value = 'value') {
      this.sentence = value
    },
    handleRadioChange(value){
      this.selected = value
    },
    onSubmit(event) {
      console.log(this.sentence)
    },
    onReset(event) {
      this.sentence = ''
    },
    getSearchData() {
      let num_output = 10;
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
  },

}


</script>
