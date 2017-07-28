
#include <caffe/caffe.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <iosfwd>
#include <memory>
#include <string>
#include <utility>
#include <vector>
#include <caffe/common.hpp>
#include <caffe/blob.hpp>
#include <C:/caffe/caffe-master/include/caffe/util/io.hpp>
#include <caffe/data_transformer.hpp>
#include "caffe/util/math_functions.hpp"
#include "caffe/util/rng.hpp"
#include <iostream>
#include <memory>
#include "head.hpp"

using namespace caffe;
#define CPU_ONLY  1

template <typename T>
cv::Mat FromBlobToCVMat(const caffe::Blob<T>& blob, int type) {

    cv::Mat cv_img = cv::Mat(blob.height(), blob.width(), type/*, input.data()->mutable_cpu_data()*/);

    for (ushort i = 0; i < blob.channels(); ++i) {
        for (ushort j = 0; j < blob.height(); ++j) {
            for (ushort k = 0; k < blob.width(); ++k) {
                cv_img.at<cv::Vec3b>(j, k)[i] = (uchar)(static_cast<int>(blob.data_at(0, i, j, k)));
            }
        }
    }

    return cv_img;
}

int main(int argc, char** argv) {

    google::InitGoogleLogging(argv[0]);

#ifdef CPU_ONLY
  caffe::Caffe::set_mode(caffe::Caffe::CPU);
#else
  caffe::Caffe::set_mode(caffe::Caffe::GPU);
#endif

  argc = 5;
  if (argc != 5) {
      std::cout << "Incorrect args.\nUsage: TestSegNet model.prototxt "
                   "weights.caffemodel input_filename output_filename" << std::endl;
      return EXIT_SUCCESS;
  }

  argv[1] = "segnet_model_driving_webdemo.prototxt";
  argv[2] = "segnet_weights_driving_webdemo.caffemodel";
  argv[3] = "3.jpg";
  argv[4] = "111.jpg";
  std::string model_filename = argv[1];
  std::string weights_filename = argv[2];
  std::string input_file = argv[3];
  std::string output_file = argv[4];

  // Loading net arch and pretraining weights
  caffe::Net<float> network(model_filename, caffe::TEST);
  network.CopyTrainedLayersFrom(weights_filename);

  // Colors for segmentation classes
  std::vector<std::vector<uchar>> color_labels;
  color_labels.push_back({128, 128, 128}); // Sky
  color_labels.push_back({128, 0, 0}); // Building
  color_labels.push_back({192, 192, 128}); // Pole
  color_labels.push_back({255, 69, 0}); // Road_marking
  color_labels.push_back({128, 64, 128}); // Road
  color_labels.push_back({60, 40, 222}); // Pavement
  color_labels.push_back({128, 128, 0}); // Tree
  color_labels.push_back({192, 128, 128}); // SignSymbol
  color_labels.push_back({64, 64, 128}); // Fence
  color_labels.push_back({64, 0, 128}); // Car
  color_labels.push_back({64, 64, 0}); // Pedestrian
  color_labels.push_back({0, 128, 192}); // Bicyclist
  color_labels.push_back({0, 0, 0}); // Unlabelled

 
  cv::Mat img = ReadImageToCVMat(input_file, 360, 480);
  cv::imshow("img", img);
  cv::waitKey();
  cv::Mat input_image(img);

  // Forwarding, didn't find better way to cast from cv::Mat to caffe::Blob
  caffe::Blob<float> input;
  input.Reshape(1, input_image.channels(), input_image.rows, input_image.cols);
  caffe::DataTransformer<float> transf(caffe::TransformationParameter(), caffe::TEST);
  transf.Transform(input_image, &input);
  std::vector<caffe::Blob<float>*> input_images;
  input_images.push_back(&input);
  // Output segmetation is indicies of colors
  //QTime timer;
  //timer.start();
  std::vector<caffe::Blob<float>*> results = network.Forward(input_images);
  //std::cout << "Time taken for one example: " << timer.elapsed() << " ms" << std::endl;

  // Processing result
  cv::Mat output_image = FromBlobToCVMat(*(results[0]), img.type());
  cv::Mat segmentation_rgb = cv::Mat(output_image.rows, output_image.cols, output_image.type());
  segmentation_rgb.reshape(3); // 3 channels BGR

  for (ushort i = 0; i < segmentation_rgb.channels(); ++i) {
      for (ushort j = 0; j < segmentation_rgb.rows; ++j) {
          for (ushort k = 0; k < segmentation_rgb.cols; ++k) {
              ushort index = static_cast<ushort>(output_image.at<cv::Vec3b>(j, k)[0]); // Only one channel in output image
              segmentation_rgb.at<cv::Vec3b>(j, k)[i] = static_cast<uchar>(color_labels[index][i]);
          }
      }
  }

  // OpenCV expects BGR instead of RGB
  cv::cvtColor(segmentation_rgb, segmentation_rgb, cv::COLOR_RGB2BGR);
  cv::imwrite(output_file, segmentation_rgb);
  std::cout << "Done!" << std::endl;
  system("pause");
  return EXIT_SUCCESS;
}
